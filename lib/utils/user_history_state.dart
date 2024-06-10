import 'package:flutter/foundation.dart';

class UserHistory {
  final String diagnosis;
  final String recommendation;
  final DateTime date;

  UserHistory({required this.diagnosis, required this.recommendation, required this.date});
}

class UserHistoryState with ChangeNotifier {
  final List<UserHistory> _history = [];

  List<UserHistory> get history => List.unmodifiable(_history);

  void addHistory(String diagnosis, String recommendation) {
    _history.add(UserHistory(diagnosis: diagnosis, recommendation: recommendation, date: DateTime.now()));
    notifyListeners();
  }
}
