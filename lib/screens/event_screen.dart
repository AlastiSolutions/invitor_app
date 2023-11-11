import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:invitor_app/main.dart';
import 'package:invitor_app/models/event.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventScreen extends StatefulWidget {
  final String eventId;

  const EventScreen({super.key, required this.eventId});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  bool _isLoading = false;

  late Event _currentEvent;

  @override
  void initState() {
    _fetchEvent();
    super.initState();
  }

  Future<void> _fetchEvent() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final data =
          await supabase.from('events').select().eq('id', widget.eventId);

      _currentEvent = Event.fromJson(data[0]);
    } on PostgrestException catch (err) {
      if (!context.mounted) return;

      Fluttertoast.showToast(
        msg: err.message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Theme.of(context).colorScheme.error,
        textColor: Theme.of(context).colorScheme.onError,
        fontSize: 14,
        timeInSecForIosWeb: 4,
      );
    } catch (err) {
      if (!context.mounted) return;

      Fluttertoast.showToast(
        msg: 'Unexpected Error Occured',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Theme.of(context).colorScheme.error,
        textColor: Theme.of(context).colorScheme.onError,
        timeInSecForIosWeb: 4,
        fontSize: 14,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _checkIfDescriptionNull() {
    Widget content = const Text('No Description for this Event.');

    if (_currentEvent.description != null) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: GoogleFonts.lato(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            _currentEvent.description!,
            style: GoogleFonts.lato(fontSize: 14),
          ),
        ],
      );
    }

    return Expanded(child: content);
  }

  Widget _checkIfDisplayEmail() {
    Widget content = const SizedBox();

    if (_currentEvent.organizerEmail != null) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Organizer Email: ',
            style: GoogleFonts.lato(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(_currentEvent.organizerEmail!),
        ],
      );
    }

    return Expanded(child: content);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.go('/profile/${_currentEvent.organizerId}');
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Column(
        children: [
          Text(
            'You have been invited to this event:',
            style: GoogleFonts.lato(fontSize: 20),
          ),
          Container(
            height: MediaQuery.of(context).size.height * .70,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * .045,
              horizontal: MediaQuery.of(context).size.width * .10,
            ),
            padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * .02,
              horizontal: MediaQuery.of(context).size.width * .05,
            ),
            decoration: BoxDecoration(
              // color: Colors.blue,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.shade500),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _currentEvent.title,
                              style: GoogleFonts.lato(fontSize: 20),
                            ),
                            Text(
                              DateFormat('yyyy-MM-DD')
                                  .format(_currentEvent.date)
                                  .substring(0, 10),
                              style: GoogleFonts.lato(fontSize: 14),
                            ),
                          ],
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .05),
                        _checkIfDescriptionNull(),
                        _checkIfDisplayEmail(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text('Accept Invite'),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text('Deny Invite'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
