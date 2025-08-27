import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AITutorService {
  static final String _apiKey = dotenv.env['GEMINI_API_KEY'] ?? 'NO_KEY';

  final GenerativeModel _model;

  AITutorService()
    : _model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: _apiKey);

  Future<String?> getExplanation({
    required String question,
    required String correctAnswer,
    required List<String> allOptions,
    // Add moduleId as a required parameter
    required String moduleId,
  }) async {
    try {
      // The prompt now dynamically includes the moduleId for a more tailored explanation.
      final prompt =
          'Explain the concept behind this multiple-choice question for a CIMA $moduleId student. '
          'The question is: "$question". '
          'The options are: ${allOptions.join(", ")}. '
          'The correct answer is "$correctAnswer". '
          'Keep the explanation concise, clear, and focused on the core principle being tested.';

      final response = await _model.generateContent([Content.text(prompt)]);
      return response.text;
    } catch (e) {
      print(e.toString());
      return 'Sorry, an error occurred while getting an explanation.';
    }
  }
}
