import 'package:flutter/material.dart';
import 'package:plant_disease_detector_app/widgets/plant_animation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lottie/lottie.dart';
import '../auth/login_screen.dart';
import '../../data/auth_repository.dart';
import '../../widgets/Stats_row.dart';
import '../../widgets/primary_button.dart';
import '../plants/add_plant_page.dart';
import '../plants/plants_page.dart';
import '../detection/disease_detect_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _supa = Supabase.instance.client;

  Future<Map<String, dynamic>> _loadStats() async {
    final uid = _supa.auth.currentUser!.id;

    final rows = await _supa.from('plants').select('id').eq('user_id', uid);

    final total = rows.length;

    final today = DateTime.now();
    final due = await _supa.rpc('plants_due_today', params: {
      'uid': uid,
      'today_date':
          DateTime(today.year, today.month, today.day).toIso8601String()
    }).catchError((_) async {
      final rows = await _supa
          .from('plants')
          .select('last_watered, watering_interval_days')
          .eq('user_id', uid);
      int dueCount = 0;
      for (final r in rows) {
        final lw = r['last_watered'] != null
            ? DateTime.parse(r['last_watered'])
            : null;
        final interval = (r['watering_interval_days'] as int?) ?? 3;
        final next = (lw ?? today.subtract(Duration(days: interval)))
            .add(Duration(days: interval));
        if (!next.isAfter(today)) dueCount++;
      }
      return {'count': dueCount};
    });

    final latest = await _supa
        .from('plants')
        .select('name')
        .eq('user_id', uid)
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    return {
      'total': total,
      'due': (due is Map && due['count'] != null)
          ? due['count'] as int
          : (due as List).length,
      'latest': latest?['name'] ?? '-',
    };
  }

  @override
  Widget build(BuildContext context) {
    final repo = AuthRepository();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Plant Care',
          style: TextStyle(color: Colors.white70),
        ),
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
      body: FutureBuilder<Map<String, dynamic>>(
        future: _loadStats(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snap.data!;
          return Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                const Text(
                  'Dashboard',
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 32,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                const PlantAnimation(),

                const SizedBox(height: 16),
                StatsRow(
                  stats: [
                    {
                      "title": "Total Plants",
                      "value": "12",
                      "icon": Icons.local_florist
                    },
                    {"title": "Tasks", "value": "5", "icon": Icons.task},
                    {
                      "title": "Detections",
                      "value": "3",
                      "icon": Icons.bug_report
                    },
                  ],
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  label: 'Bitkilerim',
                  icon: Icons.list_alt,
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const PlantsPage()));
                  },
                ),
                const SizedBox(height: 12),
                PrimaryButton(
                  label: 'Bitki Ekle',
                  icon: Icons.add_circle,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const AddPlantPage()));
                  },
                ),
                const SizedBox(height: 12),
                PrimaryButton(
                  label: 'Hastalık Tespiti (Beta)',
                  icon: Icons.camera_alt,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const DiseaseDetectPage()));
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ---- Placeholder sayfalar (sonraki adımlarda dolduracağız) ----
