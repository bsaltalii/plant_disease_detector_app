import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:plant_disease_detector_app/features/auth/register_screen.dart';
import 'package:plant_disease_detector_app/widgets/custom_button.dart';
import '../../data/auth_repository.dart';
import '../home/home_screen.dart';
import '../../widgets/field.dart';
import '../../widgets/social_button.dart';
import '../../core/responsive.dart';

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

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();
    final email = _email.text.trim();
    final pass = _password.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      _toast('Email ve şifre gerekli');
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
        _toast('Giriş başarısız. Bilgileri kontrol et.');
      }
    } catch (e) {
      _toast(e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
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
              child: Lottie.asset(
                'assets/auroralights.json',
                fit: BoxFit.fitHeight,
                repeat: true,
              ),
            ),

            Positioned.fill(
              child: Container(color: Colors.black.withOpacity(0.5)),
            ),

            // Form
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

                        // Email
                        Field(
                          controller: _email,
                          label: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          prefix: const Icon(Icons.alternate_email,
                              color: Colors.white70),
                        ),
                        const SizedBox(height: 14),

                        // Password
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

                        // Login button
                        CustomButton(
                            label: "Login",
                            onPressed: _login,
                            loading: _loading),

                        const SizedBox(height: 14),

                        // Register nav (sonra bağlarız)
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

                        // Sosyal buton placeholder (ileride ekleriz)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Social(icon: Icons.g_mobiledata),
                            SizedBox(width: 12),
                            Social(icon: Icons.apple),
                            SizedBox(width: 12),
                            Social(icon: Icons.play_circle_fill),
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
