import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final String _apiKey = dotenv.env['GEMINI_API_KEY'] ?? "";

  Future<String> getRecycleRecommendation(String wasteType) async {
    try {
      final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: _apiKey);
      
      final prompt = """
      The user has identified a piece of waste as: $wasteType. 
      Provide a concise recommendation based on the 3Rs (Reduce, Reuse, Recycle). 
      Format the response with clear steps or a short paragraph. 
      Keep it encouraging and educational.
      """;

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      
      return response.text ?? "No recommendation available at this time.";
    } catch (e) {
      return "Error fetching recommendation: $e";
    }
  }
}