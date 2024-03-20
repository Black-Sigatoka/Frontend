// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors

import 'package:black_sigatoka/api/gemini_api.dart';
import 'package:flutter/material.dart';
//import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:black_sigatoka/custom_widgets/custom_appbar.dart';

class RecommendationScreen extends StatefulWidget {
  final String diseaseSeverity;

  const RecommendationScreen({Key? key, required this.diseaseSeverity})
      : super(key: key);

  @override
  _RecommendationScreenState createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  //getRecommendations(String severity) async {
//     // Access your API key as an environment variable (see "Set up your API key" above)
//   final apiKey = String.fromEnvironment('AIzaSyBUQOV99dTBg9b-_SMIAljliGyyeWx24Qg');

//   // For text-only input, use the gemini-pro model
//   final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
//   final content = [Content.text('Provide recommendations for Black Sigatoka disease based on the severity level: $severity.')];
//   final response = await model.generateContent(content);
//   print (response.text);
// }

//   try {
//     final response = await gemini.text(
//       prompt: "Provide recommendations for Black Sigatoka disease based on the severity level: $severity.",
//       maxTokens: 100, // Adjust token limit as needed (higher for more details)
//     );
//     return response.text ?? "No recommendations available at this time.";
//   } catch (error) {
//     print(error); // Handle potential errors during API call
//     return "An error occurred. Please try again later.";
//   }
// }

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();
    String result = '';

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight), // Adjust size as needed
        child: CustomAppBar(
          title: 'Recom',
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Black Sigatoka Severity: ${widget.diseaseSeverity}',
              style: const TextStyle(fontSize: 18.0),
            ),
            Text(
              result,
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                //String recommendation = await getRecommendations(widget.diseaseSeverity);

                setState(() async {
                  result = await GeminiAPI.getGeminiData(textController.text);
                  //print(result);
                });

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('AI Chatbot Recommendation'),
                      content: Text(result),
                    );
                  },
                );
              },
              child: const Text('Get Recommendations'),
            ),
          ],
        ),
      ),
    );
  }
}
