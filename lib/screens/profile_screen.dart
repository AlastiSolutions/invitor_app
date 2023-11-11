import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invitor_app/main.dart';
import 'package:invitor_app/models/event.dart';
import 'package:invitor_app/models/user_info.dart';
import 'package:invitor_app/widgets/global/bottom_nav_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;

  late UserInfo currentUserInfo;
  late List<Event> currentUserEvents = [];

  Future<void> getUserInfo() async {
    final userID = supabase.auth.currentUser!.id;
    final data = await supabase
        .from('user_info')
        .select()
        .eq('id', userID.toString())
        .single();

    setState(() {
      currentUserInfo = UserInfo.fromJson(data);
      _isLoading = false;
    });
  }

  Future<void> getUserEvents() async {
    final userID = supabase.auth.currentUser!.id;

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

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    getUserInfo();
    getUserEvents();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: const BottomNavBar(index: 2),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * .10,
          vertical: MediaQuery.of(context).size.height * .0125,
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${currentUserInfo.firstName} ${currentUserInfo.lastName}',
                            style: GoogleFonts.lato(fontSize: 16),
                          ),
                          Text(
                            '@${currentUserInfo.username!}',
                            style: GoogleFonts.lato(fontSize: 13),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(),
                          shape: BoxShape.circle,
                        ),
                        height: MediaQuery.of(context).size.height * .125,
                        child: Image.asset(
                          'assets/images/temp_logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .10),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .55,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Your Events',
                              style: GoogleFonts.lato(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .025,
                        ),
                        Expanded(
                          child: currentUserEvents.isEmpty
                              ? const Center(child: Text('Create a new event'))
                              : ListView.builder(
                                  itemCount: currentUserEvents.length,
                                  itemBuilder: (context, index) {
                                    return _EventTile(
                                      event: currentUserEvents[index],
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _EventTile extends StatefulWidget {
  final Event event;

  const _EventTile({required this.event});

  @override
  State<_EventTile> createState() => __EventTileState();
}

class __EventTileState extends State<_EventTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(color: Colors.black12),
        ),
      ),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.event.title,
            style: GoogleFonts.abel(fontWeight: FontWeight.w700),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Invites: 20',
                style: GoogleFonts.lato(fontSize: 12),
              ),
              Text(
                'RSVP: 12',
                style: GoogleFonts.lato(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
