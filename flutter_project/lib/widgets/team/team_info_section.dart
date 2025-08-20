import 'dart:ui';

import 'package:flutter/cupertino.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Descripción del equipo",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        Text(
          team['description'] ?? 'Este es un gran equipo comprometido con el entrenamiento y la mejora continua.',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: PlayersList(players: players, controller: controller),
            ),
          ),
        ),
      ],
    );
  }
}