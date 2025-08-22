import 'package:flutter/material.dart';
import 'package:plant_disease_detector_app/widgets/plant_animation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../auth/login_screen.dart';
import '../../data/auth_repository.dart';
import '../../widgets/stats_card.dart';
import '../../widgets/action_card.dart';
import '../../data//stats_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _supa = Supabase.instance.client;
  final StatsRepository _statsService = StatsRepository();

  Future<String> _loadUsername() async {
    final uid = _supa.auth.currentUser!.id;
    final res = await _supa
        .from('profiles')
        .select('username')
        .eq('id', uid)
        .maybeSingle();
    return res?['username'] ?? 'Guest';
  }

  @override
  Widget build(BuildContext context) {
    final repo = AuthRepository();

    return FutureBuilder<String>(
      future: _loadUsername(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            backgroundColor: Color(0xFF0D1F12),
            body: Center(child: CircularProgressIndicator(color: Colors.white)),
          );
        }

        final username = snapshot.data!;

        return Scaffold(
          backgroundColor: const Color(0xFF0D1F12),
          appBar: AppBar(
            backgroundColor: const Color(0xFF0D1F12),
            elevation: 0,
            title: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Welcome, $username !',
                style: const TextStyle(color: Colors.white70, fontSize: 18),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.person_2_rounded,
                    size: 28, color: Colors.white),
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
            future: _statsService.loadStats(),
            builder: (context, snap) {
              if (!snap.hasData) {
                return const Center(
                    child: CircularProgressIndicator(color: Colors.white));
              }
              final data = snap.data!;

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Dashboard",
                        style: TextStyle(color: Colors.white70, fontSize: 32),
                      ),
                    ),
                    Expanded(
                      flex: 10,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: const PlantAnimation(),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            flex: 4,
                            child: Column(
                              children: [
                                Expanded(
                                  child: StatCard(
                                    title: "Total Plants",
                                    value: "${data['total']}",
                                    icon: Icons.local_florist,
                                  ),
                                ),
                                Expanded(
                                  child: StatCard(
                                    title: "Tasks",
                                    value: "${data['due']}",
                                    icon: Icons.task,
                                  ),
                                ),
                                Expanded(
                                  child: StatCard(
                                    title: "Latest Plant",
                                    value: "${data['latest']}",
                                    icon: Icons.bug_report,
                                  ),
                                ),
                                Expanded(
                                  child: StatCard(
                                    title: "Last Watered",
                                    value: "${data['last_watered'] ?? '-'}",
                                    icon: Icons.water_drop,
                                  ),
                                ),
                                Expanded(
                                  child: StatCard(
                                    title: "Upcoming",
                                    value: "${data['upcoming'] ?? '-'}",
                                    icon: Icons.schedule,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    Expanded(
                      flex: 2,
                      child: GridView.count(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.2,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          ActionCard(
                            icon: Icons.list_alt,
                            title: "My plants",
                            onTap: () {},
                          ),
                          ActionCard(
                            icon: Icons.add_circle,
                            title: "Add plant",
                            onTap: () {},
                          ),
                          ActionCard(
                            icon: Icons.camera_alt,
                            title: "Disease Detection",
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
