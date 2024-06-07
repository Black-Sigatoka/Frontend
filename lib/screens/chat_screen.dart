// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:provider/provider.dart';
import 'package:black_sigatoka/utils/recommendation_state.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> messages = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> getChatResponse(String query) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      const apiKey = 'AIzaSyBMtpXp1vj-mH_p0649-qU49NHqwnAl6QQ';
      final recommendation =
          Provider.of<RecommendationState>(context, listen: false)
              .recommendation;

      final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
      final content = [
        Content.text(
            "Based on the following recommendations: $recommendation, $query")
      ];
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
        errorMessage =
            "An error occurred while fetching response. Check internet connection.";
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.only(left: 90),
          child: Row(
            children: [
              Image.asset(
                'assets/images/Logo.png',
                height: 30,
                width: 30,
              ),
              const SizedBox(width: 5),
              Text(
                'Chat with us'.toUpperCase(),
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
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Card(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "AI: ${message['bot']}",
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
                  Text('Fetching Response...'),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Ask a question',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    if (_controller.text.isNotEmpty) {
                      await getChatResponse(_controller.text);
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
