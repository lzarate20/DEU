


import 'package:flutter/cupertino.dart';

import '../../services/training_service.dart';

class TrainingDetailController extends ChangeNotifier {

  final TrainingService _service = TrainingService();

  Map<String, dynamic>? training;
  List<dynamic> exercises = [];
  bool loading = true;

  Future<void> loadTraining(String id, {Map<String, dynamic>? initial}) async {
    if (initial != null) {
      _setData(initial);
      return;
    }
    training = await _service.fetchTrainingById(id);
    _setData(training);
  }

  void _setData(Map<String, dynamic>? data) {
    training = data;
    exercises = data?['exercises'] ?? [];
    loading = false;
    notifyListeners();
  }
}
