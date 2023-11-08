import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invitor_app/widgets/global/bottom_nav_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        titleTextStyle: GoogleFonts.arvo(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: const Placeholder(),
      bottomNavigationBar: const BottomNavBar(index: 0),
    );
  }
}
