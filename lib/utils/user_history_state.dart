import 'package:flutter/material.dart';

class HistoryItem {
  final String diagnosis;
  final String recommendation;
  final String date;
  final String severity;
  final String id; 

  HistoryItem({
    required this.diagnosis,
    required this.recommendation,
    required this.date,
    required this.severity,
    required this.id,
  });
}

class UserHistoryState with ChangeNotifier {
  final List<HistoryItem> _history = [];

  List<HistoryItem> get history => _history;

  void addHistory(String diagnosis, String recommendation, String date, String severity) {
    final newItem = HistoryItem(
      diagnosis: diagnosis,
      recommendation: recommendation,
      date: date,
      severity: severity,
      id: generateShortId(), 
    );
    _history.add(newItem);
    notifyListeners();
  }

  String generateShortId() {
    return DateTime.now().millisecondsSinceEpoch.toString().substring(0, 8);
  }
}
