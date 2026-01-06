import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  // ⚠️ REPLACE WITH YOUR ACTUAL API KEY
  static const String apiKey = 'YOUR_GEMINI_API_KEY_HERE';
  
  late final GenerativeModel _model;

  GeminiService() {
    _model = GenerativeModel(
      model: 'gemini-pro', 
      apiKey: apiKey,
    );
  }

  Future<String> getWasteInfo(String wasteType) async {
   final prompt = '''
      You are a helpful eco-friendly recycling assistant.
      I have a piece of waste identified as: "$wasteType".

      Please provide a response following STRICTLY this format:

      FUN FACT:
      [Write 1 short, interesting sentence about this waste]

      HOW TO RECYCLE:
      1. [First step]
      2. [Second step]
      3. [Third step]

      Rules:
      - Do not use markdown formatting (no bolding, no italics, no #).
      - Keep the steps short and imperative.
      - Do not add any intro or outro text.
      ''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      return response.text ?? "Could not fetch info at this time.";
    } catch (e) {
      return "Unable to connect to AI service. Please check your internet connection.";
    }
  }
}