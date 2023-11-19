import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invitor_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StartDrawer extends StatefulWidget {
  const StartDrawer({super.key});

  @override
  State<StartDrawer> createState() => _StartDrawerState();
}

class _StartDrawerState extends State<StartDrawer> {
  Future<void> _logout() async {
    try {
      await supabase.auth.signOut();
    } on AuthException catch (err) {
      if (!context.mounted) return;

      SnackBar(
        content: Text(err.message),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    } catch (err) {
      if (!context.mounted) return;

      SnackBar(
        content: const Text('Unexpected Error Occured!'),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    } finally {
      if (mounted) {
        context.go('/auth/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Invitor',
                      style: GoogleFonts.arvo(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                Text(
                  'Alpha v0.0.2',
                  style: GoogleFonts.openSans(fontSize: 14),
                ),
                Text(
                  'Developed by Alasti Solutions',
                  style: GoogleFonts.openSans(fontSize: 14),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * .0325,
                vertical: MediaQuery.of(context).size.height * .0125,
              ),
              child: ListView(
                children: [
                  TextButton(
                    onPressed: () {
                      context.go('/friends/${supabase.auth.currentUser!.id}');
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.people_alt_rounded),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * .05),
                        const Text('Friends'),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.go('/home/settings');
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.settings_rounded),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .05,
                        ),
                        const Text('Settings'),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: _logout,
                    child: Row(
                      children: [
                        const Icon(Icons.logout_rounded),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .05,
                        ),
                        const Text('Sign Out'),
                      ],
                    ),
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
