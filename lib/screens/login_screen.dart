import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:invitor_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final bool _isLoading = false;
  bool _isRedirecting = false;

  late final StreamSubscription<AuthState> _authStateSubscription;
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _passwordController =
      TextEditingController();

  @override
  void initState() {
    debugPrint('INIT STATE');

    _authStateSubscription = supabase.auth.onAuthStateChange.listen((event) {
      if (_isRedirecting) return;
      final session = event.session;

      if (session != null) {
        _isRedirecting = true;
        context.go('/home');
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _authStateSubscription.cancel();
    super.dispose();
  }

  Future<void> _login() async {
    // try {
    //   setState(() {
    //     _isLoading = true;
    //   });

    //   await supabase.auth.signInWithPassword(
    //     email: _emailController.text.trim(),
    //     password: _passwordController.text.trim(),
    //   );

    //   if (mounted) {
    //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //       content: Text('Successfully logged in.'),
    //     ));

    //     _emailController.clear();
    //     _passwordController.clear();
    //   }
    // } on AuthException catch (err) {
    //   debugPrint('Auth Exception');

    //   if (!context.mounted) return;

    //   SnackBar(
    //     content: Text(err.message),
    //     backgroundColor: Theme.of(context).colorScheme.error,
    //   );
    // } catch (err) {
    //   debugPrint('Unhandled Exception');

    //   if (mounted) {
    //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //       content: Text('Successfully logged in.'),
    //     ));

    //     _emailController.clear();
    //     _passwordController.clear();
    //   }
    // } finally {
    //   if (mounted) {
    //     setState(() {
    //       _isLoading = true;
    //     });
    //   }
    // }
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Container(
        height: deviceHeight,
        width: deviceWidth,
        margin: EdgeInsets.symmetric(
          horizontal: deviceWidth * .10,
          vertical: deviceHeight * .0125,
        ),
        // decoration: BoxDecoration(color: Colors.red),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                // decoration: BoxDecoration(color: Colors.blue),
                height: deviceHeight * .20,
                width: deviceHeight * .20,
                child: Image.asset('assets/images/temp_logo.png'),
              ),
            ),
            SizedBox(height: deviceHeight * .05),
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                children: [
                  _FormField(
                    controller: _emailController,
                    hintText: 'Email Address',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .05),
                  _FormField(
                    controller: _passwordController,
                    hintText: 'Password',
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .075),
                  _LoginButton(isLoading: _isLoading, login: _login),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginButton extends StatefulWidget {
  final bool isLoading;
  final void Function() login;

  const _LoginButton({required this.isLoading, required this.login});

  @override
  State<_LoginButton> createState() => __LoginButtonState();
}

class __LoginButtonState extends State<_LoginButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * .20),
      width: MediaQuery.of(context).size.width * .05,
      child: ElevatedButton(
        onPressed: widget.isLoading ? null : widget.login,
        style: ButtonStyle(
          minimumSize: MaterialStatePropertyAll(
            Size(MediaQuery.of(context).size.width * .01,
                MediaQuery.of(context).size.height * .05),
          ),
          foregroundColor: MaterialStatePropertyAll(
            Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          backgroundColor: MaterialStatePropertyAll(
            Theme.of(context).colorScheme.tertiaryContainer,
          ),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ),
        child: Text(widget.isLoading ? 'Logging In' : 'Sign In'),
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String hintText;

  const _FormField({
    required this.controller,
    required this.hintText,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .075,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade700),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Colors.black87),
          ),
        ),
      ),
    );
  }
}
