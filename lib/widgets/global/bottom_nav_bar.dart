import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:invitor_app/screens/home_screen.dart';
import 'package:invitor_app/screens/profile_screen.dart';

class BottomNavBar extends StatefulWidget {
  final int index;

  const BottomNavBar({super.key, required this.index});

  @override
  State<BottomNavBar> createState() => BottomNavBarState();
}

class BottomNavBarState extends State<BottomNavBar> {
  final screens = [
    const HomeScreen(),
    const ProfileScreen(),
  ];

  void changeIndex(int index) {
    if (index == 0) {
      context.go('/home');
    } else if (index == 1) {
      context.go('/calendar');
    } else {
      context.go('/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: changeIndex,
      currentIndex: widget.index,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      items: const [
        BottomNavigationBarItem(
          label: 'Home',
          icon: Icon(Icons.home_rounded),
        ),
        BottomNavigationBarItem(
          label: 'Calendar',
          icon: Icon(Icons.calendar_month_rounded),
        ),
        BottomNavigationBarItem(
          label: 'Profile',
          icon: Icon(Icons.person_rounded),
        ),
      ],
    );
  }
}
