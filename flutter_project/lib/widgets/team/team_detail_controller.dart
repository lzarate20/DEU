import 'package:flutter/material.dart';
import '../../services/team_service.dart';


class TeamDetailController extends ChangeNotifier {
  final TeamService _teamService = TeamService();
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
}