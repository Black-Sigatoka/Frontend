// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:black_sigatoka/utils/recommendation_state.dart';
import 'chat_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class RecommendationScreen extends StatefulWidget {
  final String diseaseSeverity;

  const RecommendationScreen({Key? key, required this.diseaseSeverity})
      : super(key: key);

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  bool isLoading = false;
  String? errorMessage;

  Future<void> getRecommendations(String severity) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      const apiKey = 'AIzaSyBMtpXp1vj-mH_p0649-qU49NHqwnAl6QQ';

      final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
      final content = [
        Content.text(
            'Provide remedies for Black Sigatoka disease based on the $severity severity level')
      ];
      final response = await model.generateContent(content);
      if (response.text != null) {
        final cleanResponse = cleanText(response.text!);
        Provider.of<RecommendationState>(context, listen: false)
            .setRecommendation(cleanResponse);
      } else {
        setState(() {
          errorMessage = "Failed to fetch recommendations.";
        });
      }
    } catch (error) {
      log(error.toString()); // Log the error for debugging
      setState(() {
        errorMessage =
            "An error occurred while fetching recommendations. Check internet connection.";
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
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            recommendations,
            style: const TextStyle(fontSize: 16.0),
          ),
        ),
      )
    ];
  }

Future<void> _saveAsFile(String content) async {
    // Request storage permission
    final status = await Permission.storage.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Storage permission is required to save the file'),
        ),
      );
      return;
    }

    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text(content),
          );
        },
      ),
    );

    final bytes = await pdf.save();

    // Get the Downloads directory
    final directory = await getExternalStorageDirectory();
    final downloadsDir = Directory('${directory!.path}/Download');
    if (!downloadsDir.existsSync()) {
      downloadsDir.createSync(recursive: true);
    }
    final filePath = '${downloadsDir.path}/recommendations.pdf';
    final file = File(filePath);
    await file.writeAsBytes(bytes);

    log('PDF saved at: $filePath'); // Log the file path for debugging

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('PDF downloaded successfully at $filePath'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recommendation =
        Provider.of<RecommendationState>(context).recommendation;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
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
                const Row(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(width: 10.0),
                    Text('Fetching Recommendations...'),
                  ],
                ),
              if (recommendation.isNotEmpty) ...[
                ...buildRecommendations(recommendation),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () async {
                    await _saveAsFile(recommendation);
                  },
                  child: const Text('Download PDF'),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChatScreen(),
                      ),
                    );
                  },
                  child: const Text('Ask Follow-up Questions'),
                ),
              ],
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
