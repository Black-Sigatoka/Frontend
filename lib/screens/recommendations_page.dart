// ignore: duplicate_ignore
// ignore: library_private_types_in_public_api, //prefer_const_constructors
// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:black_sigatoka/custom_widgets/custom_appbar.dart';
//import 'package:dotenv/dotenv.dart' as dotenv;

class RecommendationScreen extends StatefulWidget {
  final String diseaseSeverity;

  const RecommendationScreen({Key? key, required this.diseaseSeverity})
      : super(key: key);

  @override
  _RecommendationScreenState createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  Future<String?> getRecommendations(String severity) async {
    try {

      final apiKey = Platform.environment['API_KEY'];

      if (apiKey == null) {
        print('No \$API_KEY environment variable');
        exit(1);
      }

      final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
      final content = [
        Content.text(
            'Provide recommendations for Black Sigatoka disease based on the severity level:')
      ];
      final response = await model.generateContent(content);
      return response.text;
    } catch (error) {
      print(error); // Log the error for debugging
      return "An error occurred while fetching recommendations.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight), // Adjust size as needed
        child: CustomAppBar(
          title: 'Recom',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Black Sigatoka Severity: ${widget.diseaseSeverity}',
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const AlertDialog(
                      title: Text('Fetching Recommendations...'),
                      content: Row(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(width: 10.0),
                          Text('Please wait'),
                        ],
                      ),
                    );
                  },
                );

                String? recommendation =
                    await getRecommendations(widget.diseaseSeverity);
                Navigator.pop(context); // Close the initial progress dialog

                List<String> recommendations = recommendation!.split('.');
                String firstRecommendation = recommendations.first.trim();

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('AI Chatbot Recommendations'),
                      content: Text(firstRecommendation),
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
