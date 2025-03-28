import 'dart:convert';
import 'package:http/http.dart' as http;

class HealthTipsService {
  final String apiKey = "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";
  final String apiUrl = "https://openrouter.ai/api/v1/chat/completions";

  Future<String> fetchHealthTip() async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $apiKey",
        },
        body: jsonEncode({
          "model": "openai/gpt-3.5-turbo",
          "messages": [
            {"role": "system", "content": "You are a helpful assistant providing daily health tips."},
            {"role": "user", "content": "You are a health assistant. Provide a single health tip as a quote every day. The response should only contain the quote without any additional text"}
          ]
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData["choices"][0]["message"]["content"].trim();
      } else {
        return "Error: Unable to fetch health tip.";
      }
    } catch (e) {
      return "Error: $e";
    }
  }
}