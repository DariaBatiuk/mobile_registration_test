import 'package:flutter/material.dart';
import 'package:mobile_registration_test/auth/auth_service.dart';
import 'package:mobile_registration_test/login/authoriszed_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final AuthServise _authServise = AuthServise();

  bool _loading = false;
  bool _code = false;

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _showSnackBarMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  bool _isEmailValid(String email) {
    if (email.isEmpty) {
      _showSnackBarMessage('Enter your email');
      return false;
    }
    if (!email.contains('@') || !email.contains('.')) {
      _showSnackBarMessage('Email is not valid');
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F7),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Container(
                        height: 180,
                        width: double.infinity,
                        color: Color(0xFFFFC727),
                      ),
                      Positioned(
                        right: -40,
                        top: -20,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.yellow.shade200,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Positioned(
                        left: -40,
                        top: 20,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.yellow.shade100,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 18,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            SizedBox(height: 8),
                            Text(
                              'Login to your account',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 4),
                            Spacer(),
                            Text(
                              'Your Mobile App',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Sign in',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Use your email to receive a login code.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              hintText: 'email@example.com',
                              prefixIcon: const Icon(Icons.email_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (_code) ...[
                            TextField(
                              controller: _codeController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Code from email',
                                hintText: '12345',
                                prefixIcon: const Icon(
                                  Icons.lock_outline_rounded,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: _loading ? null : () {},
                                child: const Text('Send code again'),
                              ),
                            ),
                            const SizedBox(height: 8),
                          ] else
                            const SizedBox(height: 8),
                          const SizedBox(height: 8),
                          if (_loading)
                            const Center(child: CircularProgressIndicator())
                          else
                            SizedBox(
                              height: 52,
                              child: FilledButton(
                                onPressed: () async {
                                  final email = _emailController.text
                                      .toLowerCase()
                                      .trim();

                                  if (!_isEmailValid(email)) {
                                    return;
                                  }
                                  if (!_code) {
                                    setState(() => _loading = true);
                                    try {
                                      await _authServise.requestCode(email);
                                      setState(() {
                                        _code = true;
                                      });
                                      _showSnackBarMessage(
                                        'Code is sent to your email.',
                                      );
                                    } catch (error) {
                                      _showSnackBarMessage(
                                        'Failed to send you code.',
                                      );
                                    } finally {
                                      setState(() {
                                        _loading = false;
                                      });
                                    }
                                  } else {
                                    final code = _codeController.text
                                        .toLowerCase()
                                        .trim();

                                    if (code.isEmpty) {
                                      _showSnackBarMessage('Enter the code.');
                                      return;
                                    }

                                    setState(() {
                                      _loading = true;
                                    });

                                    try {
                                      final tokens = await _authServise
                                          .confirmCode(email, code);
                                          await _authServise.saveToken(tokens);
                                      final userId = await _authServise
                                          .getUserId(tokens.jwt);

                                      if (!mounted) return;

                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => 
                                          AuthorizedScreen(userId: userId),
                                          )
                                      );
                                    } catch (error) {
                                      _showSnackBarMessage('Failed to login');
                                    } finally {
                                      setState(() {
                                        _loading = false;
                                      });
                                    }
                                  }
                                },
                                style: FilledButton.styleFrom(
                                  backgroundColor: Color(0xFFFFC727),
                                  foregroundColor: Colors.black87,
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(_code ? 'Login' : 'Get code'),
                              ),
                            ),
                          const SizedBox(height: 16),
                          const Divider(height: 24),
                          const Center(
                            child: Text(
                              'By continuing you agree with our Terms & Privacy.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black45,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
