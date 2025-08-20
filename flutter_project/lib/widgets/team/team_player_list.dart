import 'package:flutter/material.dart';
import 'package:flutter_project/services/auth_service.dart';
import 'package:flutter_project/widgets/team/team_detail_controller.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PlayersList extends StatelessWidget {
  final List<dynamic> players;
  final TeamDetailController controller;

  const PlayersList({super.key, required this.players, required this.controller});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: const FlutterSecureStorage().read(key: 'user_id'),
      builder: (context, snapshot) {
        final currentUserId = snapshot.data;
        final alreadyInTeam = currentUserId != null && players.any((p) => p['id'].toString() == currentUserId);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Jugadores", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                FutureBuilder<bool?>(
                  future: AuthService.isTrainee(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox.shrink();
                    }
                    final isTrainee = snapshot.data ?? false;

                    if (!isTrainee) {
                      return SizedBox.shrink();
                    }

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
                        final success = await controller.addCurrentUserToTeam(currentUserId!);
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
                )
              ],
            ),
            const Divider(thickness: 2, height: 20),
            Expanded(
              child: players.isNotEmpty
                  ? ListView.builder(
                itemCount: players.length,
                itemBuilder: (context, index) {
                  final player = players[index];
                  return ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(player['name'] ?? 'Jugador'),
                    subtitle: Text(player['position'] ?? 'Sin posición'),
                  );
                },
              )
                  : const Center(child: Text('No hay jugadores asignados.')),
            ),
          ],
        );
      },
    );
  }
}