import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../widgets/custom_button.dart';

class PlantDetailPage extends StatefulWidget {
  final Map<String, dynamic> plant;

  const PlantDetailPage({super.key, required this.plant});

  @override
  State<PlantDetailPage> createState() => _PlantDetailPageState();
}

class _PlantDetailPageState extends State<PlantDetailPage> {
  final supabase = Supabase.instance.client;
  bool _loading = false;

  Future<void> _waterPlant() async {
    setState(() => _loading = true);
    try {
      await supabase
          .from('plants')
          .update({'last_watered': DateTime.now().toIso8601String()})
          .eq('id', widget.plant['id']);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Plant watered! 🌱")),
        );
        setState(() {
          widget.plant['last_watered'] = DateTime.now().toIso8601String();
        });
      }
    } catch (e) {
      debugPrint("Error watering plant: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to water plant")),
        );
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final plant = widget.plant;

    return Scaffold(
      backgroundColor: const Color(0xFF0D1F12),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1F12),
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white70,
            )),
        title: Text(
          plant['name'] ?? "Plant Detail",
          style: const TextStyle(color: Colors.white70),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Bilgi kutusu
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(Icons.local_florist, "Type",
                      plant['species'] ?? '-'),
                  const Divider(color: Colors.white24, height: 24),
                  _buildInfoRow(Icons.water_drop, "Watering Interval",
                      "${plant['watering_interval_days'] ?? '?'} days"),
                  const Divider(color: Colors.white24, height: 24),
                  _buildInfoRow(
                    Icons.calendar_today,
                    "Last Watered",
                    plant['last_watered'] ?? 'Not yet',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            CustomButton(label: "Mark as watered", onPressed: _loading ? null : _waterPlant),

          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.greenAccent, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 13, color: Colors.white54, height: 1.2)),
              Text(value,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }
}
