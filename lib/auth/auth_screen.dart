import 'package:flutter/material.dart';
import 'package:mobile_registration_test/login/login_screen.dart';
import 'package:mobile_registration_test/login/authoriszed_screen.dart';
import 'package:mobile_registration_test/auth/auth_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthServise _authService = AuthServise();

  bool _loading = true;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    try {
      final tokens = await _authService.getToken();

      if (tokens == null) {
        setState(() => _loading = false);
        return;
      }

      try {
        final userId = await _authService.getUserId(tokens.jwt);
        setState(() {
          _userId = userId;
          _loading = false;
        });
        return;
      } catch (_) {
      
      }

      final newTokens = await _authService.refreshToken(tokens.refreshToken);
      await _authService.saveToken(newTokens);

      final userId = await _authService.getUserId(newTokens.jwt);

      setState(() {
        _userId = userId;
        _loading = false;
      });
    } catch (e) {
      await _authService.clearToken();
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_userId != null) {
      return AuthorizedScreen(userId: _userId!);
    }

    return const LoginScreen();
  }
}
