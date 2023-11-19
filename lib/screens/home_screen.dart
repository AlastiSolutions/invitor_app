import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

import 'package:invitor_app/main.dart';
import 'package:invitor_app/models/event.dart';
import 'package:invitor_app/models/user_info.dart';
import 'package:invitor_app/widgets/global/bottom_nav_bar.dart';
import 'package:invitor_app/widgets/global/start_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  List<Event> authUserEvents = [];

  final authUser = supabase.auth.currentUser;
  late UserInfo authUserInfo;

  Future<void> _fetchUserInfo() async {
    try {
      final data =
          await supabase.from('user_info').select().eq('id', authUser!.id);

      authUserInfo = UserInfo.fromJson(data[0]);
    } on PostgrestException catch (err) {
      if (!context.mounted) return;

      Fluttertoast.showToast(
        msg: err.message,
        gravity: ToastGravity.TOP,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 4,
        fontSize: 14,
        backgroundColor: Theme.of(context).colorScheme.error,
        textColor: Theme.of(context).colorScheme.onError,
      );
    } catch (err) {
      if (!context.mounted) return;

      Fluttertoast.showToast(
        msg: 'An Unexpected error occuring try to fetch your data',
        gravity: ToastGravity.TOP,
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 4,
        fontSize: 14,
        backgroundColor: Theme.of(context).colorScheme.error,
        textColor: Theme.of(context).colorScheme.onError,
      );
    } finally {
      _fetchUserEvents();
    }
  }

  Future<void> _fetchUserEvents() async {
    try {
      final data = await supabase
          .from('events')
          .select()
          .eq('organizer_id', authUser!.id);

      for (final event in data) {
        final newEvent = Event.fromJson(event);
        setState(() {
          authUserEvents.add(newEvent);
        });
      }
    } on PostgrestException catch (err) {
      if (!context.mounted) return;

      Fluttertoast.showToast(
        msg: err.message,
        gravity: ToastGravity.TOP,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 4,
        fontSize: 14,
        backgroundColor: Theme.of(context).colorScheme.error,
        textColor: Theme.of(context).colorScheme.onError,
      );
    } catch (err) {
      if (!context.mounted) return;

      Fluttertoast.showToast(
        msg: 'An Unexpected error occuring try to fetch your events',
        gravity: ToastGravity.TOP,
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 4,
        fontSize: 14,
        backgroundColor: Theme.of(context).colorScheme.error,
        textColor: Theme.of(context).colorScheme.onError,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });

      Fluttertoast.showToast(
        msg: 'Successfully fetched data',
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: const Color.fromARGB(255, 93, 240, 101),
        textColor: Colors.black,
        timeInSecForIosWeb: 1,
      );
    }
  }

  Event? findNextEvent() {
    final now = DateTime.now();

    if (authUserEvents.isEmpty) return null;

    final events =
        authUserEvents.where((element) => element.date.isAfter(now)).toList();
    events.sort((dayOne, dayTwo) => dayOne.date.compareTo(dayTwo.date));

    return events[0];
  }

  Event? findLastEvent() {
    final now = DateTime.now();

    if (authUserEvents.isEmpty) return null;

    final events =
        authUserEvents.where((element) => element.date.isBefore(now)).toList();

    events.sort((dayOne, dayTwo) => dayOne.date.compareTo(dayTwo.date));

    final eventsLength = events.length;

    return events[eventsLength - 1];
  }

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.go('/home/add_calendar');
            },
          ),
        ],
      ),
      drawer: const StartDrawer(),
      bottomNavigationBar: const BottomNavBar(index: 0),
      body: Container(
        height: deviceHeight,
        width: deviceWidth,
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * .045),
        // decoration: const BoxDecoration(color: Colors.blue),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back, @${authUserInfo.username}',
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .025),
                  // _eventWidgets(),
                  TextButton(
                    onPressed: () {
                      context
                          .go('/profile/453f112c-ef00-4a07-8522-2dbf8c94e596');
                    },
                    child: const Text('View Kourosh Spams Profile'),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _eventWidgets() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Next Event:',
              style: GoogleFonts.lato(fontSize: 16),
            ),
            Container(
              height: MediaQuery.of(context).size.height * .125,
              width: MediaQuery.of(context).size.width * .375,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 218, 218, 218),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      findNextEvent() == null
                          ? 'Create first event'
                          : findNextEvent()!.title,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_month_rounded),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * .0125),
                        Text(
                          findLastEvent() == null
                              ? ''
                              : DateFormat('yMMMd')
                                  .format(findNextEvent()!.date),
                          style: GoogleFonts.lato(fontSize: 18),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Your Last Event:',
              style: GoogleFonts.lato(fontSize: 16),
            ),
            Container(
              height: MediaQuery.of(context).size.height * .125,
              width: MediaQuery.of(context).size.width * .375,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 218, 218, 218),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      findLastEvent() == null
                          ? 'Create first event'
                          : findLastEvent()!.title,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_month_rounded),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * .0125),
                        Text(
                          findLastEvent() == null
                              ? ''
                              : DateFormat('yMMMd')
                                  .format(findLastEvent()!.date),
                          style: GoogleFonts.lato(fontSize: 18),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
