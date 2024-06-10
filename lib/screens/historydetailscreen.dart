
import 'package:black_sigatoka/utils/user_history_state.dart';
import 'package:flutter/material.dart';

class HistoryDetailScreen extends StatelessWidget {
  final HistoryItem history;

  const HistoryDetailScreen({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
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
                'History Detail'.toUpperCase(),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Diagnosis ID: ${history.id}', style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10.0),
            Text('Date: ${history.date}', style: const TextStyle(fontSize: 16.0)),
            const SizedBox(height: 10.0),
            Text('Severity: ${history.severity}', style: const TextStyle(fontSize: 16.0)),
            const SizedBox(height: 10.0),
            Text('Diagnosis: ${history.diagnosis}', style: const TextStyle(fontSize: 16.0)),
            const SizedBox(height: 10.0),
            Text('Recommendation: ${history.recommendation}', style: const TextStyle(fontSize: 16.0)),
          ],
        ),
      ),
    );
  }
}
