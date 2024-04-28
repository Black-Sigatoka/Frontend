// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
// import 'package:black_sigatoka/utils/recommendation_utils.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

class RecommendationScreen extends StatefulWidget {
  final String diseaseSeverity;

  const RecommendationScreen({Key? key, required this.diseaseSeverity})
      : super(key: key);

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  Future<String?> getRecommendations(String severity) async {
    //showRecommendations(context, severity);

    try {
      
      const apiKey = 'AIzaSyBMtpXp1vj-mH_p0649-qU49NHqwnAl6QQ';

      if (apiKey == null) {
        throw Exception('API_KEY environment variable not found');
      }

      final model =
          GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
      final content = [
        Content.text(
            'Provide remedies for Black Sigatoka disease based on the $severity severity level')
      ];
      final response = await model.generateContent(content);
      return response.text;
    } catch (error) {
      log(error.toString()); // Log the error for debugging
      return "An error occurred while fetching recommendations.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.white,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                'assets/images/Logo.png',
                height: 30,
                width: 30,
              ),
            ),
            const SizedBox(width: 5),
            Center(
              child: Text(
                'Recommendations'.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
          ],
        ),
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

                if (recommendation != null) {
                  List<String> recommendations = recommendation.split('.');
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
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: const Text('Failed to fetch recommendations.'),
                      );
                    },
                  );
                }
              },
              child: const Text('Get Recommendations'),
            ),
          ],
        ),
      ),
    );
  }
}
