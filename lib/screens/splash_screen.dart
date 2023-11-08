import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';

import 'package:invitor_app/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _onSessionExistsRedirect();
  }

  Future<void> _onSessionExistsRedirect() async {
    await Future.delayed(const Duration(milliseconds: 4200));

    if (!mounted) {
      debugPrint('Splash Screen Not Mounted. Exit Page');
      return;
    }
    final session = supabase.auth.currentSession;

    if (session != null) {
      debugPrint('Going To Home');
      context.go('/home');
    } else {
      debugPrint('[LOGIN PAGE]: SUPABASE AUTH SESSION NULL');
      context.go('/auth/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen.gif(
      gifPath: 'assets/images/test.gif',
      gifWidth: 269,
      gifHeight: 474,
      useImmersiveMode: true,
      asyncNavigationCallback: () async {
        await Future.delayed(const Duration(milliseconds: 4000));
        debugPrint('*** 4 SECOND DELAY ***');

        if (!context.mounted) return;
        context.go('/auth');
      },
      onInit: () async {
        debugPrint('*** Init Splash Screen ***');
        await Future.delayed(const Duration(milliseconds: 1000));
        debugPrint('*** 1 Second Delay after Init ***');
      },
      onEnd: () async {
        debugPrint('*** End Splash Screen ***');
      },
    );
  }
}
