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

  Future<void> _deletePlant(dynamic id) async {
    try {
      await supabase.from('plants').delete().eq('id', id);
      setState(() {});
    } catch (e) {
      debugPrint("Error deleting plant: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to delete plant")),
      );
    }
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
            return const Center(child: CircularProgressIndicator(color: Colors.white70));
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
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text("Delete Plant"),
                          content: const Text("Are you sure you want to delete this plant?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text("Cancel",style: TextStyle(color: Colors.black)),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text("Delete", style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        _deletePlant(plant['id']);
                      }
                    },
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
