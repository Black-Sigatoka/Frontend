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
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> messages = [];
  bool isLoading = false;
  String? errorMessage;
  String conversationHistory = '';

  Future<void> getRecommendations(String query) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      const apiKey = 'AIzaSyBMtpXp1vj-mH_p0649-qU49NHqwnAl6QQ';

      if (apiKey == null) {
        throw Exception('API_KEY environment variable not found');
      }

      final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
      final content = [Content.text('$conversationHistory\nUser: $query\nBot:')];
      final response = await model.generateContent(content);
      if (response.text != null) {
        setState(() {
          String cleanedResponse = cleanText(response.text!);
          messages.add({"user": query, "bot": cleanedResponse});
          conversationHistory += '\nUser: $query\nBot: $cleanedResponse';
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
    // Remove asterisks, replace 'eg' with 'for example', and trim the text
    return text.replaceAll('*', '').replaceAll('eg', 'for example').trim();
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
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "User: ${message['user']}",
                            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Card(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Bot: ${message['bot']}",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          if (isLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(width: 10.0),
                  Text('Fetching Recommendations...'),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Ask a question...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    final query = _controller.text.trim();
                    if (query.isNotEmpty) {
                      _controller.clear();
                      await getRecommendations(query);
                    }
                  },
                ),
              ],
            ),
          ),
          if (errorMessage != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Error: $errorMessage',
                style: const TextStyle(fontSize: 16.0, color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }
}
