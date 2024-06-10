import 'package:black_sigatoka/screens/historydetailscreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:black_sigatoka/utils/user_history_state.dart';

class UserHistoryScreen extends StatelessWidget {
  const UserHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userHistory = Provider.of<UserHistoryState>(context).history;

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
                'User History'.toUpperCase(),
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
      body: ListView.builder(
        itemCount: userHistory.length,
        itemBuilder: (context, index) {
          final history = userHistory[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text('Diagnosis ID: ${history.id}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Date: ${history.date}'),
                  Text('Severity: ${history.severity}'),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HistoryDetailScreen(history: history),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

