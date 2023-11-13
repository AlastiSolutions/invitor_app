import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:invitor_app/main.dart';
import 'package:invitor_app/models/event.dart';
import 'package:invitor_app/widgets/global/bottom_nav_bar.dart';

class EventCalendarScreen extends StatefulWidget {
  final String userId;

  const EventCalendarScreen({super.key, required this.userId});

  @override
  State<EventCalendarScreen> createState() => _EventCalendarScreenState();
}

class _EventCalendarScreenState extends State<EventCalendarScreen> {
  bool _isLoading = false;

  late final ValueNotifier<List<Event>> _selectedEvents;
  final RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.disabled;

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  List<Event> userEvents = [];
  Map<DateTime, List<Event>> eventSource = {};
  LinkedHashMap<DateTime, List<Event>> loadedEvents =
      LinkedHashMap<DateTime, List<Event>>();

  @override
  void initState() {
    super.initState();
    fetchUserEvents();

    _selectedEvents = ValueNotifier(_eventLoader(_focusedDay));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  Future<void> fetchUserEvents() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final dbEvents = await supabase.from('events').select().eq(
            'organizer_id',
            widget.userId.toString(),
          );

      for (final event in dbEvents) {
        final newEvent = Event.fromJson(event);

        userEvents.add(newEvent);
      }

      createHashMap();
    } on PostgrestException catch (err) {
      if (!context.mounted) return;

      Fluttertoast.showToast(
        msg: err.message,
        textColor: Theme.of(context).colorScheme.onError,
        backgroundColor: Theme.of(context).colorScheme.error,
        gravity: ToastGravity.SNACKBAR,
        toastLength: Toast.LENGTH_LONG,
        fontSize: 14,
        timeInSecForIosWeb: 5,
      );
    } catch (err) {
      if (!context.mounted) return;

      Fluttertoast.showToast(
        msg: 'Unexpected Error Occured during Event Loading',
        timeInSecForIosWeb: 4,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        backgroundColor: Theme.of(context).colorScheme.error,
        textColor: Theme.of(context).colorScheme.error,
        fontSize: 14,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void createHashMap() {
    eventSource = Map.fromIterable(
      userEvents,
      key: (event) => event.date as DateTime,
      value: (event) => List.generate(1, (index) => event as Event),
    );

    loadedEvents = LinkedHashMap<DateTime, List<Event>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(eventSource);
  }

  List<Event> _eventLoader(DateTime day) {
    return loadedEvents[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      if (!isSameDay(_selectedDay, selectedDay)) {
        _selectedDay = selectedDay;
      }

      _focusedDay = focusedDay;
    });

    _selectedEvents.value = _eventLoader(_selectedDay);

    // (selectedDay, focusedDay) {
    //           setState(() {
    //             _selectedDay = selectedDay;
    //             _focusedDay = focusedDay;
    //           });
    //         },
  }

  bool _selectedDayPredicate(DateTime day) {
    return isSameDay(_selectedDay, day);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Your Calendar',
          style: GoogleFonts.lato(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: const BottomNavBar(index: 1),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                TableCalendar(
                  focusedDay: _focusedDay,
                  firstDay: DateTime.now(),
                  lastDay: DateTime(2100),
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: _selectedDayPredicate,
                  rangeSelectionMode: _rangeSelectionMode,
                  eventLoader: _eventLoader,
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
                  child: ValueListenableBuilder(
                    valueListenable: _selectedEvents,
                    builder: (context, value, _) {
                      return ListView.builder(
                        itemCount: value.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                                onTap: () =>
                                    context.go('/events/${value[index].id}'),
                                title: Text(value[index].title)),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
