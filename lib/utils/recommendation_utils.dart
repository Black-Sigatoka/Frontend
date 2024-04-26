// ignore_for_file: prefer_const_constructors

export 'recommendation_utils.dart';

import 'package:black_sigatoka/screens/recommendations_page.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';

void showRecommendations(BuildContext context, String severity, String imagecopy) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      Uint8List bytes = base64Decode(imagecopy);
      return AlertDialog(
        title: const Center(child: Text("Severity Level")),
        content: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Image.memory(
                    bytes,
                    width: 150,
                    height: 150,
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: Text(
                    severity,
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RecommendationScreen(diseaseSeverity: severity)),
                );
              },
              child: const Text("Recommendations"),
            ),
          ),
        ],
      );
    },
  );
}