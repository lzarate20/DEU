import 'package:flutter/material.dart';
import 'package:flutter_project/services/auth_service.dart';
import 'package:flutter_project/widgets/team/team_detail_controller.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

import '../trainer/training_card.dart';
import '../training/trainings_list_widget.dart';

class PlayersList extends StatelessWidget {
  final List<dynamic> players;
  final TeamDetailController controller;
  final int teamId;

  const PlayersList({
    super.key,
    required this.players,
    required this.controller,
    required this.teamId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Map<String, String> positionMap = {
      'DEFENCE': 'Defensa',
      'MIDFIELD': 'Mediocampo',
      'FORWARD': 'Delantero',
    };

    return FutureBuilder<String?>(
      future: AuthService.getLoggedUserId(),
      builder: (context, snapshot) {
        final currentUserId = snapshot.data;
        final alreadyInTeam =
            currentUserId != null && players.any((p) => p['id'].toString() == currentUserId);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Jugadores", style: theme.textTheme.titleMedium),
                FutureBuilder<bool?>(
                  future: AuthService.isTrainee(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox.shrink();
                    }
                    final isTrainee = snapshot.data ?? false;
                    if (!isTrainee) return const SizedBox.shrink();

                    return IconButton(
                      icon: Icon(
                        Icons.person_add,
                        color: alreadyInTeam ? Colors.grey : Colors.green,
                      ),
                      tooltip: alreadyInTeam
                          ? 'Ya estás en el equipo'
                          : 'Sumarse al equipo',
                      onPressed: alreadyInTeam
                          ? null
                          : () async {
                        final success =
                        await controller.addCurrentUserToTeam(currentUserId!);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                success
                                    ? 'Te sumaste al equipo!'
                                    : 'No se pudo sumar al equipo.',
                              ),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ],
            ),
            const Divider(thickness: 2, height: 20),
            Flexible(
              child: players.isNotEmpty
                  ? ListView.builder(
                itemCount: players.length,
                itemBuilder: (context, index) {
                  final player = players[index];
                  return ListTile(
                    leading: const Icon(Icons.person),
                    title: Semantics(
                      label: 'Nombre del jugador',
                      child: Text(player['name'] ?? 'Jugador',
                          style: theme.textTheme.bodyLarge),
                    ),
                    subtitle: Semantics(
                      label: 'Posición en el campo',
                      child: Text(
                        positionMap[player['position']] ?? 'Sin posición',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),

                    trailing: (currentUserId == controller.teamTrainerId)
                        ? Semantics(
                      button: true,
                      enabled: true,
                      label: 'Ver entrenamientos futuros de ${player['name']}',
                      child: IconButton(
                        icon: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                          padding: const EdgeInsets.all(6),
                          child: const Icon(
                            Icons.list,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        tooltip: 'Ver entrenamientos futuros',
                        onPressed: () async {
                          final trainings = await controller.fetchFutureTrainingsUserByTeam(
                            teamId,
                            int.parse(player['id'].toString()),
                          );

                          if (trainings != null && context.mounted) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('${player['name']} - Próximos entrenamientos'),
                                  content: SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.6,
                                    height: 400,
                                    child: ListView.builder(
                                      itemCount: trainings.length,
                                      itemBuilder: (context, index) {
                                        final training = trainings[index];
                                        return TrainingCard(
                                          training: training,
                                          onTap: () {
                                            Navigator.pop(context);
                                            context.go('/training/${training['id']}', extra: training);
                                          },
                                          onAdd: () {},
                                        );
                                      },
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cerrar'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('No se pudieron obtener los entrenamientos'),
                              ),
                            );
                          }
                        },
                      ),
                    )
                        : null,

                  );

                },
              )
                  : Center(
                child: Text(
                  'No hay jugadores asignados.',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}



