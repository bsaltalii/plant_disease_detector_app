import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

Future<String> analyzeWithGemini(File imageFile) async {
  final apiKey = dotenv.env['GEMINI_API_KEY'];
  if (apiKey == null) {
    throw Exception("Missing GEMINI_API_KEY in .env");
  }

  final model = GenerativeModel(
    model: "gemini-1.5-flash",
    apiKey: apiKey,
  );

  final imageBytes = await imageFile.readAsBytes();

  final response = await model.generateContent([
    Content.multi([
      TextPart("Analyze this plant leaf photo. "
          "Give me: 1) Disease name, 2) Causes, 3) Suggested solutions. "
          "Be short and clear."),
      DataPart("image/jpeg", imageBytes),
    ])
  ]);

  return response.text?.replaceAll("*", "") ?? "No result";
}
