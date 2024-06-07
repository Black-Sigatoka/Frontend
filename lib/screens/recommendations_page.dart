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
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> messages = [];

  Future<void> getRecommendations(String severity) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
      recommendation = null;
    });

    try {
      const apiKey = 'YOUR_API_KEY_HERE';

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

  Future<void> getChatResponse(String query) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      const apiKey = 'YOUR_API_KEY_HERE';

      final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
      final content = [Content.text(query)];
      final response = await model.generateContent(content);
      if (response.text != null) {
        setState(() {
          final cleanResponse = cleanText(response.text!);
          messages.add({"user": query, "bot": cleanResponse});
        });
      } else {
        setState(() {
          errorMessage = "Failed to fetch response.";
        });
      }
    } catch (error) {
      log(error.toString()); // Log the error for debugging
      setState(() {
        errorMessage = "An error occurred while fetching response. Check internet connection.";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String cleanText(String text) {
    return text.replaceAll('*', '').replaceAll('eg', 'for example').trim();
  }

  List<Widget> buildRecommendations(String recommendations) {
    return [
      Card(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            recommendations,
            style: TextStyle(fontSize: 16.0),
          ),
        ),
      )
    ];
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
          ),
          if (recommendation != null) ...[
            Divider(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
                        await getChatResponse(query);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
