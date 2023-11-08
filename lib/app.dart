import 'package:flutter/material.dart';

import 'package:invitor_app/main.dart';
import 'package:invitor_app/theme/theme.dart';
import 'package:invitor_app/constants/router.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool currentUserAuthenticated = false;

  @override
  void initState() {
    if (supabase.auth.currentUser != null) onAppRestart();

    super.initState();
  }

  void onAppRestart() {
    setState(() {
      currentUserAuthenticated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Invitor',
      theme: theme,
      routerConfig: router,
    );
  }
}
