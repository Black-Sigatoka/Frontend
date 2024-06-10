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
                'User History and Analytics'.toUpperCase(),
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
          return ListTile(
            title: Text('Diagnosis: ${history.diagnosis}'),
            subtitle: Text('Recommendation: ${history.recommendation}\nDate: ${history.date}'),
          );
        },
      ),
    );
  }
}
