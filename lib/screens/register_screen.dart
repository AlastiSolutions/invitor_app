import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final bool _isLoading = false;
  // bool _isRedirecting = false;

  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _usernameController =
      TextEditingController();
  late final TextEditingController _passwordController =
      TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _register() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * .10,
          vertical: MediaQuery.of(context).size.height * .0125,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.20,
                width: MediaQuery.of(context).size.height * 0.20,
                child: Image.asset('assets/images/temp_logo.png'),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .05),
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                children: [
                  _FormField(
                    controller: _emailController,
                    hintText: 'Email Address',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .05),
                  _FormField(
                    controller: _usernameController,
                    hintText: 'Username',
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .05),
                  _FormField(
                    controller: _passwordController,
                    hintText: 'Password',
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .025),
                  Row(
                    children: [
                      const Text('Already have an account? '),
                      SizedBox(width: MediaQuery.of(context).size.width * .025),
                      TextButton(
                        onPressed: () {
                          context.go('/auth/login');
                        },
                        child: const Text('Login Now'),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .075),
                  _RegisterButton(isLoading: _isLoading, register: _register),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RegisterButton extends StatefulWidget {
  final bool isLoading;
  final void Function() register;

  const _RegisterButton({
    required this.isLoading,
    required this.register,
  });

  @override
  State<_RegisterButton> createState() => __RegisterButtonState();
}

class __RegisterButtonState extends State<_RegisterButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * .20,
      ),
      width: MediaQuery.of(context).size.width * .05,
      child: ElevatedButton(
        onPressed: widget.isLoading ? null : widget.register,
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
        child: Text(widget.isLoading ? 'Registering' : "Register"),
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
      height: MediaQuery.of(context).size.height * 0.075,
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
