import 'package:flutter/material.dart';
import 'package:flutter_project/widgets/team/team_detail_controller.dart';
import 'package:flutter_project/widgets/team/team_player_list.dart';

class TeamInfoSection extends StatelessWidget {
  final Map<String, dynamic> team;
  final List<dynamic> players;
  final TeamDetailController controller;

  const TeamInfoSection({
    super.key,
    required this.team,
    required this.players,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Descripción del equipo", style: theme.textTheme.titleSmall),
        const SizedBox(height: 10),
        Text(
          team['description'] ??
              'Este es un gran equipo comprometido con el entrenamiento y la mejora continua.',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 20),
        Expanded(
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: PlayersList(players: players, controller: controller,teamId: team['id'] ,),
            ),
          ),
        ),
      ],
    );
  }
}
