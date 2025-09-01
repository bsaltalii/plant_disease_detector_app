import 'package:flutter/material.dart';
import 'package:plant_disease_detector_app/widgets/custom_button.dart';
import 'dart:io';
import '../../services/gemini_service.dart';
import '../home/home_screen.dart'; // kendi pathine göre düzenle

class DiseaseResultPage extends StatefulWidget {
  final File image;
  const DiseaseResultPage({super.key, required this.image});

  @override
  State<DiseaseResultPage> createState() => _DiseaseResultPageState();
}

class _DiseaseResultPageState extends State<DiseaseResultPage> {
  bool _loading = true;
  String? _result;

  @override
  void initState() {
    super.initState();
    _analyze();
  }

  Future<void> _analyze() async {
    try {
      final result = await analyzeWithGemini(widget.image);
      setState(() {
        _result = result;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _result = "Error: $e";
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1F12),
      appBar: AppBar(
        title: const Text("Analysis Result",
            style: TextStyle(color: Colors.white70)),
        backgroundColor: const Color(0xFF0D1F12),
        automaticallyImplyLeading: false
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                width: double.infinity,
                child: Image.file(widget.image, fit: BoxFit.cover),
              ),
            ),
          ),
          _loading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white70),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _result ?? "No result",
                      style: const TextStyle(
                          color: Colors.white, fontSize: 16, height: 1.4, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
          if (!_loading && _result != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                      label: "Back to Home",
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()),
                          (route) => false,
                        );
                      })),
            )
        ],
      ),
    );
  }
}
