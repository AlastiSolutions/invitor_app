import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:invitor_app/main.dart';
import 'package:invitor_app/models/event.dart';
import 'package:invitor_app/widgets/global/bottom_nav_bar.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  final String userId;

  const CalendarScreen({super.key, required this.userId});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  late List<Event> currentUserEvents = [];

  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  Future<void> getUserEvents() async {
    final userID = widget.userId;

    final events = await supabase.from('events').select().eq(
          'organizer_id',
          userID.toString(),
        );

    for (final event in events) {
      final newEvent = Event.fromJson(event);
      setState(() {
        currentUserEvents.add(newEvent);
      });
    }
  }

  late final events = LinkedHashMap<DateTime, List<Event>>(
    equals: isSameDay,
    hashCode: getHashCode,
  )..addAll(_eventSource);

  // final _eventSource = Map.fromIterable(
  //   List.generate(, (index) => index),
  //   key: (item) => DateTime.utc(),
  // );

  @override
  void initState() {
    getUserEvents();

    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForSelectedDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForSelectedDay(DateTime day) {
    return events[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null;
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForSelectedDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: const BottomNavBar(index: 1),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * .1,
          vertical: MediaQuery.of(context).size.height * .0125,
        ),
        child: Column(
          children: [
            TableCalendar<Event>(
              locale: 'en_US',
              calendarFormat: _calendarFormat,
              rangeSelectionMode: _rangeSelectionMode,
              focusedDay: DateTime.now(),
              firstDay: DateTime.now(),
              lastDay: DateTime(2100),
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              eventLoader: _getEventsForSelectedDay,
              calendarStyle: const CalendarStyle(outsideDaysVisible: false),
              onDaySelected: _onDaySelected,
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .0125),
            Expanded(
              child: ValueListenableBuilder<List<Event>>(
                valueListenable: _selectedEvents,
                builder: (context, value, _) {
                  return ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * .0125,
                          vertical: MediaQuery.of(context).size.height * .010,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          onTap: () => print('${value[index]}'),
                          title: Text('${value[index]}'),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
