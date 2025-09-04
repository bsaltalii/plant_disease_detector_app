import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_input.dart';

class AddPlantPage extends StatefulWidget {
  const AddPlantPage({super.key});

  @override
  State<AddPlantPage> createState() => _AddPlantPageState();
}

class _AddPlantPageState extends State<AddPlantPage> {
  final _nameController = TextEditingController();
  String? _selectedType;
  int? _wateringFrequency;
  bool _loading = false;

  Future<void> _savePlant() async {
    if (_nameController.text.isEmpty ||
        _selectedType == null ||
        _wateringFrequency == null) {
      showMessage(context, "Missing Information", "Please fill in all fields.");
      return;
    }

    setState(() => _loading = true);

    try {
      final supabase = Supabase.instance.client;
      final userId = supabase.auth.currentUser!.id;

      await supabase.from('plants').insert({
        'user_id': userId,
        'name': _nameController.text,
        'species': _selectedType,
        'watering_interval_days': _wateringFrequency,
        'created_at': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        showMessage(context, "Success", "Plant has been added successfully!");
      }
    } catch (e) {
      debugPrint("Error inserting plant: $e");
      showMessage(context, "Error", "Something went wrong $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  void showMessage(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(
          title,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        content: Text(
          message,
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            child: const Text(
              "OK",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1F12),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white70,
            )),
        backgroundColor: const Color(0xFF0D1F12),
        elevation: 0,
        title: const Text("Add Plant", style: TextStyle(color: Colors.white70)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("New Plant",
                style: TextStyle(color: Colors.white70, fontSize: 28)),
            const SizedBox(height: 24),

            CustomInput<String>(
              label: "Plant Type",
              isDropdown: true,
              value: _selectedType,
              items: const [
                DropdownMenuItem(value: "Flower", child: Text("Flower")),
                DropdownMenuItem(value: "Tree", child: Text("Tree")),
                DropdownMenuItem(value: "Herb", child: Text("Herb")),
              ],
              onChanged: (val) => setState(() => _selectedType = val),
            ),

            const SizedBox(height: 16),

            CustomInput<int>(
              label: "Watering Frequency",
              isDropdown: true,
              value: _wateringFrequency,
              items: const [
                DropdownMenuItem(value: 1, child: Text("Every day")),
                DropdownMenuItem(value: 3, child: Text("Every 3 days")),
                DropdownMenuItem(value: 7, child: Text("Every week")),
              ],
              onChanged: (val) => setState(() => _wateringFrequency = val),
            ),

            const SizedBox(height: 16),

            CustomInput(
              label: "Plant Name",
              controller: _nameController,
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: _loading
                  ? const Center(
                child: CircularProgressIndicator(color: Colors.white70),
              )
                  : CustomButton(
                label: "Save Plant",
                onPressed: _loading ? null : _savePlant,
              ),
            )

          ],
        ),
      ),
    );
  }
}
