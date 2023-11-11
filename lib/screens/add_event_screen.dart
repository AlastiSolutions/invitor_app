import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:invitor_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddCalendarScreenState();
}

class _AddCalendarScreenState extends State<AddEventScreen> {
  // bool _isLoading = false;
  // bool _isCreating = false;
  bool _showEmail = false;

  late final TextEditingController _titleController = TextEditingController();
  late final TextEditingController? _descriptionController =
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
    final description = _descriptionController!.text.trim();

    try {
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
    } finally {
      _titleController.clear();
      _dateController.clear();
      _descriptionController!.clear();
      _locationController.clear();

      setState(() {
        _showEmail = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * .045),
        child: ListView(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Event Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                hintText: 'Event Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            TextFormField(
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
            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(
                hintText: 'Event Location',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
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
            ElevatedButton(
              onPressed: _createEvent,
              child: const Text('Create Event'),
            ),
          ],
        ),
      ),
    );
  }
}
