import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../data/auth_repository.dart';
import '../home/home_screen.dart';

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
            // 🌌 Arka plan Lottie (assets/sprout.json)
            Positioned.fill(
              child: Lottie.asset(
                'assets/sprout.json',
                fit: BoxFit.contain,
                repeat: true,
              ),
            ),

            // Koyu bir overlay okunabilirlik için
            Positioned.fill(
              child: Container(color: Colors.black.withOpacity(0.45)),
            ),

            // Form
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 460),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 8),
                        const Text(
                          'Brilliance.\nLogin',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Email
                        _Field(
                          controller: _email,
                          label: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          prefix: const Icon(Icons.alternate_email, color: Colors.white70),
                        ),
                        const SizedBox(height: 14),

                        // Password
                        _Field(
                          controller: _password,
                          label: 'Password',
                          obscure: _obscure,
                          prefix: const Icon(Icons.lock_outline, color: Colors.white70),
                          suffix: IconButton(
                            onPressed: () => setState(() => _obscure = !_obscure),
                            icon: Icon(
                              _obscure ? Icons.visibility : Icons.visibility_off,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),

                        // Login button
                        SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: _loading ? null : _login,
                            child: _loading
                                ? const SizedBox(
                              width: 22, height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                                : const Text('Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Register nav (sonra bağlarız)
                        TextButton(
                          onPressed: () {
                            // TODO: RegisterScreen'e yönlendirme
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
                            _Social(icon: Icons.g_mobiledata),
                            SizedBox(width: 12),
                            _Social(icon: Icons.apple),
                            SizedBox(width: 12),
                            _Social(icon: Icons.play_circle_fill),
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

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscure;
  final TextInputType? keyboardType;
  final Widget? prefix;
  final Widget? suffix;

  const _Field({
    required this.controller,
    required this.label,
    this.obscure = false,
    this.keyboardType,
    this.prefix,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.greenAccent,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.10),
        prefixIcon: prefix,
        suffixIcon: suffix,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.25)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.20)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.greenAccent, width: 1.2),
        ),
      ),
    );
  }
}

class _Social extends StatelessWidget {
  final IconData icon;
  const _Social({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: IconButton(
        onPressed: () {},
        icon: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}
