import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/auth_repository.dart';
import '../auth/login_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _supa = Supabase.instance.client;
  final repo = AuthRepository();

  String? _username;
  String? _email;
  String? _name;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final uid = _supa.auth.currentUser?.id;
    final userEmail = _supa.auth.currentUser?.email;

    if (uid != null) {
      final res = await _supa
          .from('profiles')
          .select('username, created_at')
          .eq('id', uid)
          .maybeSingle();

      setState(() {
        _username = res?['username'] ?? "Guest";
        _email = userEmail ?? "-";
      });
    }
  }

  Future<void> _logout() async {
    await repo.signOut();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
      );
    }
  }

  Widget _buildInfoTile(IconData icon, String title, String subtitle, Color iconColor) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor, size: 32),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.white70),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1F12),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1F12),
        title: const Text("Profile", style: TextStyle(color: Colors.white70)),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white70),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 60, color: Colors.black),
            ),
            const SizedBox(height: 16),
            Text(
              _username ?? "Loading...",
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              _email ?? "",
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
            const SizedBox(height: 20),


            _buildInfoTile(Icons.account_circle, "Username", _username ?? "-", Colors.blue),
            _buildInfoTile(Icons.email, "E-mail", _email ?? "-", Colors.red),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _logout,
                child: const Text("Log Out",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
