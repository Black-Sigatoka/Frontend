// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class RecommendationScreen extends StatefulWidget {
  final String diseaseSeverity;

  const RecommendationScreen({Key? key, required this.diseaseSeverity})
      : super(key: key);

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  String? recommendation;
  bool isLoading = false;
  String? errorMessage;

  Future<void> getRecommendations(String severity) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
      recommendation = null;
    });

    try {
      const apiKey = 'AIzaSyBMtpXp1vj-mH_p0649-qU49NHqwnAl6QQ';

      if (apiKey == null) {
        throw Exception('API_KEY environment variable not found');
      }

      final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
      final content = [
        Content.text(
            'Provide remedies for Black Sigatoka disease based on the $severity severity level')
      ];
      final response = await model.generateContent(content);
      if (response.text != null) {
        setState(() {
          recommendation = cleanText(response.text!);
        });
      } else {
        setState(() {
          errorMessage = "Failed to fetch recommendations.";
        });
      }
    } catch (error) {
      log(error.toString()); // Log the error for debugging
      setState(() {
        errorMessage = "An error occurred while fetching recommendations. Check internet connection.";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String cleanText(String text) {
    // Remove asterisks and trim the text
    return text.replaceAll('*', '').trim();
  }

  List<Widget> buildRecommendations(String recommendations) {
    List<String> recommendationList = recommendations.split('.');
    return recommendationList
        .where(
            (rec) => rec.trim().isNotEmpty) // Filter out empty recommendations
        .map((rec) => Card(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  rec.trim(),
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/Logo.png',
                height: 30,
                width: 30,
              ),
              const SizedBox(width: 5),
              Text(
                'Recommendations'.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Black Sigatoka Severity: ${widget.diseaseSeverity}',
                style: const TextStyle(fontSize: 15.0),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  await getRecommendations(widget.diseaseSeverity);
                },
                child: const Text('Get Recommendations'),
              ),
              const SizedBox(height: 20.0),
              if (isLoading)
                Row(
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(width: 10.0),
                    Text('Fetching Recommendations...'),
                  ],
                ),
              if (recommendation != null)
                ...buildRecommendations(recommendation!),
              if (errorMessage != null)
                Text(
                  'Error: $errorMessage',
                  style: const TextStyle(fontSize: 16.0, color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
