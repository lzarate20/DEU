import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../../widgets/team/team_detail_controller.dart';
import '../../widgets/team/team_info_section.dart';
import '../../widgets/team/team_trainer_card.dart';


class TeamDetailPage extends StatelessWidget {
  final String teamId;
  final Map<String, dynamic>? team;

  const TeamDetailPage({super.key, required this.teamId, this.team});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final controller = TeamDetailController();
        controller.fetchTeam(teamId);
        return controller;
      },
      child: Consumer<TeamDetailController>(
        builder: (context, controller, _) {
          if (controller.loading && controller.team == null) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final _team = controller.team;
          if (_team == null) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  "Equipo no encontrado",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              body: Center(
                child: Text(
                  "No se encontró la información del equipo.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            );
          }

          final List<dynamic> users = _team['users'] ?? [];
          final trainer = users.firstWhere(
                (user) => user['type'] == 'TRAINER',
            orElse: () => null,
          );
          final players =
          users.where((u) => u['type'] == 'TRAINEE').toList();

          return Scaffold(
            appBar: AppBar(
              title: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  _team['name'] ?? 'Equipo',
                  style: Theme.of(context).textTheme.headlineSmall, // antes displaySmall
                ),
              ),
              toolbarHeight: 80,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: TeamInfoSection(
                      team: _team,
                      players: players,
                      controller: controller,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(flex: 1, child: TrainerCard(trainer: trainer)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


