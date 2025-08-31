import 'package:flutter/material.dart';
import 'package:flutter_project/services/training_service.dart';
import 'package:flutter_project/services/user_service.dart';
import '../../services/team_service.dart';


class TeamDetailController extends ChangeNotifier {
  final TeamService _teamService = TeamService();
  final TrainingService _trainingService = TrainingService();
  Map<String, dynamic>? _team;
  bool _loading = false;

  Map<String, dynamic>? get team => _team;
  bool get loading => _loading;

  Future<void> fetchTeam(String teamId) async {
    _loading = true;
    notifyListeners();

    try {
      final data = await _teamService.fetchTeamById(teamId);
      _team = data;
    } catch (e) {
      _team = null;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> addCurrentUserToTeam(String userId) async {
    if (_team == null) return false;
    final success = await _teamService.addUserToTeam(_team!['id'].toString(), userId);
    if (success) {
      await fetchTeam(_team!['id'].toString());
    }
    return success;
  }

  Future<List<Map<String, dynamic>>?> fetchFutureTrainingsUserByTeam(int teamId, int userId) async {
    try {
      final trainings = await _trainingService.fetchFutureTrainingsUserByTeam(teamId, userId);
      return trainings;
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic>? get teamTrainer {
    final List<dynamic> users = _team?['users'] ?? [];
    return users.firstWhere(
          (user) => user['type'] == 'TRAINER',
      orElse: () => null,
    );
  }

  String? get teamTrainerId => teamTrainer?['id']?.toString();
}