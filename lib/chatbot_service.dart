import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatbotService {
  final String apiKey = "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";
  final String apiUrl = "https://openrouter.ai/api/v1/chat/completions";

  Future<String> sendMessage(String message, {String? pastAppointments, String? healthTip}) async {
    try {
      List<Map<String, String>> messages = [
        {
          "role": "system",
          "content": "You are an AI assistant inside the Global HealthCure app. "
              "You help users with doctor recommendations, past appointments, health tips, and chatbot consultations. "
              "You should provide medical guidance while also directing users to relevant features in the app."
        },
        if (pastAppointments != null)
          {
            "role": "system",
            "content": "User's past appointments: $pastAppointments"
          },
        if (healthTip != null)
          {
            "role": "system",
            "content": "Daily health tip: $healthTip"
          },
        {
          "role": "user",
          "content": message
        }
      ];

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $apiKey",
        },
        body: jsonEncode({
          "model": "openai/gpt-3.5-turbo",
          "messages": messages
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData["choices"][0]["message"]["content"];
      } else {
        return "Error: ${response.body}";
      }
    } catch (e) {
      return "Failed to connect to chatbot service.";
    }
  }
}