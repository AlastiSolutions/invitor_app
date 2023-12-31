import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:invitor_app/screens/event_screen.dart';
import 'package:invitor_app/screens/friends_screen.dart';
// import 'package:invitor_app/main.dart';
import 'package:invitor_app/screens/settings_screen.dart';

import 'package:invitor_app/screens/splash_screen.dart';
import 'package:invitor_app/screens/login_screen.dart';
import 'package:invitor_app/screens/register_screen.dart';
import 'package:invitor_app/screens/home_screen.dart';
import 'package:invitor_app/screens/event_calendar_screen.dart';
import 'package:invitor_app/screens/add_event_screen.dart';
import 'package:invitor_app/screens/profile_screen.dart';

Page<dynamic> buildPage(Widget page) {
  return CustomTransitionPage(
    child: page,
    transitionDuration: const Duration(milliseconds: 400),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}

Page<dynamic> buildAddEventPage(
  Widget page,
) {
  return CustomTransitionPage(
    child: page,
    transitionDuration: const Duration(milliseconds: 250),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
    },
  );
}

final router = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: '/',
  // redirectLimit: 1,
  // redirect: (context, state) {
  //   debugPrint('Redirecting');
  //   if (supabase.auth.currentUser != null) {
  //     return '/home';
  //   } else {
  //     return null;
  //   }
  // },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/auth',
      pageBuilder: (context, state) => buildPage(const LoginScreen()),
      routes: [
        GoRoute(
          path: 'register',
          pageBuilder: (context, state) => buildPage(const RegisterScreen()),
        ),
        GoRoute(
          path: 'login',
          pageBuilder: (context, state) => buildPage(const LoginScreen()),
        ),
      ],
    ),
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) => buildPage(const HomeScreen()),
      routes: [
        GoRoute(
          path: 'add_calendar',
          pageBuilder: (context, state) => buildAddEventPage(
            const AddEventScreen(),
          ),
        ),
        GoRoute(
          path: 'settings',
          pageBuilder: (context, state) => buildPage(const SettingsScreen()),
        ),
      ],
    ),
    GoRoute(
      path: '/calendar/:userId',
      pageBuilder: (context, state) => buildPage(
          EventCalendarScreen(userId: state.pathParameters['userId']!)),
    ),
    GoRoute(
      path: '/events/:eventId',
      pageBuilder: (context, state) => buildPage(
        EventScreen(eventId: state.pathParameters['eventId']!),
      ),
    ),
    GoRoute(
      path: '/profile/:userId',
      pageBuilder: (context, state) => buildPage(
        ProfileScreen(profileId: state.pathParameters['userId']!),
      ),
    ),
    GoRoute(
      path: '/friends/:userId',
      pageBuilder: (context, state) => buildPage(
        FriendsScreen(profileId: state.pathParameters['userId']!),
      ),
    ),
  ],
);
