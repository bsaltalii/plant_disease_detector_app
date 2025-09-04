import 'dart:async';
import 'package:flutter/material.dart';
import 'package:plant_disease_detector_app/features/auth/register_screen.dart';
import 'package:plant_disease_detector_app/widgets/custom_button.dart';
import '../../data/auth_repository.dart';
import '../home/home_screen.dart';
import '../../widgets/login_register_input.dart';
import '../../widgets/social_button.dart';
import '../../core/responsive.dart';
import 'show_message.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _repo = AuthRepository();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;
  bool _obscure = true;

  late final StreamSubscription<AuthState> _authSub;

  @override
  void initState() {
    super.initState();

    // ✅ Google/Apple login sonrası otomatik yakalama
    _authSub = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      final session = data.session;

      if (event == AuthChangeEvent.signedIn &&
          session != null &&
          mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _authSub.cancel();
    super.dispose();
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();
    final email = _email.text.trim();
    final pass = _password.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      showMessage(
          context, "Missing Information", "Email and password are required.");
      return;
    }

    setState(() => _loading = true);
    try {
      final res = await _repo.signIn(email, pass);
      if (res.user != null && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        showMessage(context, "Login Failed",
            "Login unsuccessful. Please check your credentials.");
      }
    } catch (e) {
      showMessage(context, "Login Failed",
          "Login unsuccessful. Please check your credentials.");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/bg.png',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(color: Colors.black.withOpacity(0.5)),
            ),

            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: R.padding(context),
                  child: ConstrainedBox(
                    constraints:
                    BoxConstraints(maxWidth: R.maxFormWidth(context)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Plant Care.\nLogin',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: R.titleSize(context),
                              fontWeight: FontWeight.w800,
                              height: 1.1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        Field(
                          controller: _email,
                          label: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          prefix: const Icon(Icons.alternate_email,
                              color: Colors.white70),
                        ),
                        const SizedBox(height: 14),

                        Field(
                          controller: _password,
                          label: 'Password',
                          obscure: _obscure,
                          prefix: const Icon(Icons.lock_outline,
                              color: Colors.white70),
                          suffix: IconButton(
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                            icon: Icon(
                              _obscure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),

                        CustomButton(
                          label: "Login",
                          onPressed: _login,
                          loading: _loading,
                        ),

                        const SizedBox(height: 14),

                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const RegisterScreen()),
                            );
                          },
                          child: const Text(
                            "Don’t have an account? Sign up",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),

                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Google
                            GestureDetector(
                              onTap: () async {
                                final started =
                                await _repo.signInWithGoogle();
                                if (!started) {
                                  showMessage(context, "Error",
                                      "Could not start Google sign-in.");
                                }
                              },
                              child: const Social(icon: Icons.g_mobiledata),
                            ),
                            const SizedBox(width: 12),

                            // Apple
                            GestureDetector(
                              onTap: () async {
                                final started =
                                await _repo.signInWithApple();
                                if (!started) {
                                  showMessage(context, "Error",
                                      "Could not start Apple sign-in.");
                                }
                              },
                              child: const Social(icon: Icons.apple),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
