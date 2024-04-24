// ignore_for_file: prefer_const_constructors

export 'recommendation_utils.dart';

import 'package:black_sigatoka/screens/recommendations_page.dart';
import 'package:flutter/material.dart';

void showRecommendations(BuildContext context, String severity) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Center(child: Text("Severity Level")),
        content: Padding(
          padding: EdgeInsets.only(left: 90.0),
          child: Text(
            severity,
            style: TextStyle(color: Colors.green),
          ),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RecommendationScreen(
                              diseaseSeverity: severity,
                            )));
              },
              child: const Text("Recommendations"),
            ),
          ),
        ],
      );
    },
  );
}
