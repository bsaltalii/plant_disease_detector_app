import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:plant_disease_detector_app/widgets/custom_button.dart';
import 'disease_result_page.dart';

class DiseaseDetectPage extends StatefulWidget {
  const DiseaseDetectPage({super.key});

  @override
  State<DiseaseDetectPage> createState() => _DiseaseDetectPageState();
}

class _DiseaseDetectPageState extends State<DiseaseDetectPage> {
  final picker = ImagePicker();
  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    final picked = await picker.pickImage(source: source);
    if (picked != null) {
      setState(() => _image = File(picked.path));
    }
  }

  void _clearImage() {
    setState(() {
      _image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1F12),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1F12),
        title: const Text("Disease Detection",
            style: TextStyle(color: Colors.white70)),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white70),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              width: double.infinity,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: _image == null
                        ? const Center(
                      child: Text(
                        "No image selected",
                        style: TextStyle(color: Colors.white54),
                      ),
                    )
                        : ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(
                        _image!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ),
                  if (_image != null)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: _clearImage,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(6),
                          child: const Icon(Icons.close,
                              color: Colors.white, size: 18),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            Row(
              children: [
                if (_image == null) ...[
                  Expanded(
                    child: CustomButton(
                      label: "Camera",
                      onPressed: () => _pickImage(ImageSource.camera),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      label: "Gallery",
                      onPressed: () => _pickImage(ImageSource.gallery),
                    ),
                  ),
                ] else ...[
                  Expanded(
                    child: CustomButton(
                      label: "Analyze",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DiseaseResultPage(image: _image!),
                          ),
                        );
                      },
                    ),
                  ),
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }
}
