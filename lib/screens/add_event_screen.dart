import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:invitor_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddCalendarScreenState();
}

class _AddCalendarScreenState extends State<AddEventScreen> {
  bool _isLoading = false;
  bool _createdEvent = true;
  bool _showEmail = false;

  late final TextEditingController _titleController = TextEditingController();
  late final TextEditingController _descriptionController =
      TextEditingController();
  late final TextEditingController _dateController = TextEditingController();
  late final TextEditingController _locationController =
      TextEditingController();

  late DateTime _date;

  final _organizerId = supabase.auth.currentUser!.id;
  final _organizerEmail = supabase.auth.currentUser!.email;
  final _inviteCount = 0;
  final _rsvpCount = 0;

  Future<void> _createEvent() async {
    final title = _titleController.text.trim();
    final location = _locationController.text.trim();
    final description = _descriptionController.text.trim();

    try {
      setState(() {
        _isLoading = true;
      });

      await supabase.from('events').insert({
        'created_at': DateTime.now().toIso8601String(),
        'title': title,
        'description': description.length > 1 ? description : null,
        'date': _date.toIso8601String(),
        'location': location,
        'organizer_id': _organizerId,
        'organizer_email': _showEmail ? _organizerEmail : null,
        'invite_count': _inviteCount,
        'rsvp_count': _rsvpCount,
      });
    } on PostgrestException catch (err) {
      if (!context.mounted) return;

      Fluttertoast.showToast(
        msg: err.message,
        gravity: ToastGravity.TOP,
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 5,
        backgroundColor: Theme.of(context).colorScheme.error,
        textColor: Theme.of(context).colorScheme.onError,
        fontSize: 14,
      );

      setState(() {
        _createdEvent = false;
      });
    } catch (err) {
      if (!context.mounted) return;

      Fluttertoast.showToast(
        msg: 'Unexpected Error Occured',
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 4,
        backgroundColor: Theme.of(context).colorScheme.error,
        textColor: Theme.of(context).colorScheme.onError,
        fontSize: 14,
      );

      setState(() {
        _createdEvent = false;
      });
    } finally {
      _titleController.clear();
      _dateController.clear();
      _descriptionController.clear();
      _locationController.clear();

      setState(() {
        _isLoading = false;
        _showEmail = false;
      });
    }

    if (!context.mounted) return;
    if (_createdEvent) {
      Navigator.pop(context);

      Fluttertoast.showToast(
        msg: 'Event Created',
        gravity: ToastGravity.SNACKBAR,
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 3,
        backgroundColor: const Color.fromARGB(255, 93, 240, 101),
        textColor: Colors.black,
        fontSize: 14,
      );
    } else {
      Fluttertoast.showToast(
        msg: 'Event not created. Please try again!',
        gravity: ToastGravity.TOP,
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 4,
        backgroundColor: Theme.of(context).colorScheme.error,
        textColor: Theme.of(context).colorScheme.onError,
        fontSize: 14,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * .045),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: 'Event Title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * .0125),
                Expanded(
                  child: TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: 'Event Date',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );

                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);

                        setState(() {
                          _date = pickedDate;
                          _dateController.text = formattedDate;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .025),
            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(
                hintText: 'Event Location',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .025),
            TextFormField(
              expands: false,
              minLines: 1,
              maxLines: 3,
              textAlign: TextAlign.start,
              textAlignVertical: TextAlignVertical.top,
              controller: _descriptionController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * .025,
                  right: MediaQuery.of(context).size.width * .025,
                  bottom: MediaQuery.of(context).size.height * .1,
                  top: MediaQuery.of(context).size.height * .025,
                ),
                hintText: 'Event Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .0125),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Show Email on Event",
                  style: GoogleFonts.lato(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Switch(
                  value: _showEmail,
                  onChanged: (val) {
                    setState(() {
                      _showEmail = val;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .0125),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * .20,
              ),
              child: ElevatedButton(
                onPressed: _createEvent,
                style: ButtonStyle(
                  fixedSize: MaterialStatePropertyAll(
                    Size(
                      MediaQuery.of(context).size.width * .10,
                      MediaQuery.of(context).size.height * .05,
                    ),
                  ),
                  backgroundColor: MaterialStatePropertyAll(
                    Theme.of(context).colorScheme.primaryContainer,
                  ),
                  foregroundColor: MaterialStatePropertyAll(
                    Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Create Event'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
