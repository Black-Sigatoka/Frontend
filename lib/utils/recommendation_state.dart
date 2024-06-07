import 'package:flutter/foundation.dart';

class RecommendationState with ChangeNotifier {
  String _recommendation = '';

  String get recommendation => _recommendation;

  void setRecommendation(String recommendation) {
    _recommendation = recommendation;
    notifyListeners();
  }
}
