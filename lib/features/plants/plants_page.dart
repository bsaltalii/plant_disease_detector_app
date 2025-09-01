import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../plants/plant_detail_page.dart';

class PlantsPage extends StatefulWidget {
  const PlantsPage({super.key});

  @override
  State<PlantsPage> createState() => _PlantsPageState();
}

class _PlantsPageState extends State<PlantsPage> {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> _loadPlants() async {
    final uid = supabase.auth.currentUser!.id;
    final res = await supabase
        .from('plants')
        .select()
        .eq('user_id', uid)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(res);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0D1F12),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white70,
            )),
        title: Text(
          "My Plants",
          style: TextStyle(color: Colors.white70),
        ),
        backgroundColor: Color(0xFF0D1F12),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _loadPlants(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final plants = snapshot.data!;
          if (plants.isEmpty) {
            return const Center(
              child: Text(
                "No plants yet 🌱",
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: plants.length,
            itemBuilder: (context, index) {
              final plant = plants[index];
              return Card(
                color: Colors.grey[900],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: Image.asset(
                    'assets/${plant['species'].toString().toLowerCase()}.png',
                    width: 32,
                  ),
                  title: Text(
                    plant['name'] ?? "Unnamed",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  subtitle: Text(
                    "Type: ${plant['species'] ?? '-'} • Every ${plant['watering_interval_days'] ?? '?'} days",
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PlantDetailPage(plant: plant),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
