import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutrition_app/screens/auth/login_screen.dart';
import 'package:nutrition_app/screens/auth/register_screen.dart';

// Define AuthMode enum at the top level so it can be exported
enum AuthMode { login, register }

class AuthScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> onboardingData;
  final AuthMode initialMode;

  const AuthScreen({
    super.key,
    required this.onboardingData,
    this.initialMode = AuthMode.register,
  });

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  late bool _showLogin;

  @override
  void initState() {
    super.initState();
    _showLogin = widget.initialMode == AuthMode.login;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_showLogin ? 'Login' : 'Create Account'),
        centerTitle: true,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _showLogin
            ? LoginScreen(
                onRegisterClick: () {
                  setState(() {
                    _showLogin = false;
                  });
                },
              )
            : RegisterScreen(
                onboardingData: widget.onboardingData,
                onLoginClick: () {
                  setState(() {
                    _showLogin = true;
                  });
                },
              ),
      ),
    );
  }
}