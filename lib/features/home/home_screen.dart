import 'package:flutter/material.dart';
import '../auth/login_screen.dart';
import '../../data/auth_repository.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = AuthRepository();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Plant Disease App"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await repo.signOut();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              }
            },
          )
        ],
      ),
      body: const Center(
        child: Text(
          "Hoş geldin 👋",
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
