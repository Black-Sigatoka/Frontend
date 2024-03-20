import 'dart:convert';
//import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;

class GeminiAPI {
  //create a header
  static Future<Map<String, String>> getHeader() async {
    return {
      'Content-Type': 'application/json',
    };
  }

  //create an http request
  static Future<String> getGeminiData(String text) async {
    String message = 'user message';

    try {
      final header = await getHeader();

      final Map<String, dynamic> requestBody = {
        'contents': [
          {
            'parts': [
              {
                'text': 'user message request here $message',
              }
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.8,
          'maxOutputTokens': 1000, //max tokens to generate result
        }
      };

      String url =
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.0-pro:generateContent?key=AIzaSyBUQOV99dTBg9b-_SMIAljliGyyeWx24Qg';

      // send request using above data
      var response = await http.post(Uri.parse(url),
          headers: header, body: jsonEncode(requestBody));

      print(response.body); //incase of any errors

      if (response.statusCode == 200) {
        //200 is for a success response

        var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return jsonResponse['candidates'][0]['content']['parts'][0]
            ['text']; //returns result from gemini
      } else {
        return '';
      }
    } catch (e) {
      print("Error: $e");
      return '';
    }
  }
}
