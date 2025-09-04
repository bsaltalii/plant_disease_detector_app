import 'package:flutter/material.dart';
import 'package:plant_disease_detector_app/widgets/custom_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lottie/lottie.dart';
import 'login_screen.dart';
import '../../widgets/login_register_input.dart';
import '../../core/responsive.dart';
import 'show_message.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _userCtrl = TextEditingController();
  bool _loading = false;
  bool _obscure = true;

  Future<void> _register() async {
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text.trim();
    final username = _userCtrl.text.trim();

    if (email.isEmpty || pass.isEmpty || username.isEmpty) {
      showMessage(context, "Missing Information", "All fields are required.");
      return;
    }

    setState(() => _loading = true);

    try {
      final res = await Supabase.instance.client.auth.signUp(
        email: email,
        password: pass,
      );

      if (res.user != null) {
        await Supabase.instance.client.from('profiles').insert({
          'id': res.user!.id,
          'username': username,
        });

        if (mounted) {
          showMessage(context, "Success", "Registration successful! Please log in.");
          Future.delayed(const Duration(seconds: 3));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        }
      } else {
        showMessage(context, "Registration Failed", "Registration unsuccessful. Please try again.");
      }
    } catch (e) {
      if (mounted) {
        showMessage(context, "Error", "Please check your e-mail and password!");
      }
    } finally {
      setState(() => _loading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/bg.png',
                fit: BoxFit.cover, //
              ),
            ),
            Positioned.fill(
              child: Container(color: Colors.black.withOpacity(0.5)),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Plant Care.\nRegister',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: R.titleSize(context),
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Field(
                    controller: _userCtrl,
                    label: 'Username',
                    obscure: false,
                    prefix:
                        const Icon(Icons.supervised_user_circle_outlined, color: Colors.white70),
                  ),
                  const SizedBox(height: 24),
                  Field(
                    controller: _emailCtrl,
                    label: 'E-mail',
                    obscure: false,
                    prefix:
                        const Icon(Icons.alternate_email, color: Colors.white70),
                  ),
                  const SizedBox(height: 24),
                  Field(
                    controller: _passCtrl,
                    label: 'Password',
                    obscure: _obscure,
                    prefix:
                        const Icon(Icons.lock_outline, color: Colors.white70),
                    suffix: IconButton(
                      onPressed: () => setState(() => _obscure = !_obscure),
                      icon: Icon(
                        _obscure ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      label: "Sign Up",
                      onPressed: _register,
                      loading: _loading,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Already have an account? Login",
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
