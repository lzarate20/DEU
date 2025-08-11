import 'package:flutter/material.dart';

class TeamCard extends StatelessWidget {
  final Map<String, dynamic> team;
  final Map<String, dynamic>? coach;
  final VoidCallback? onTap;

  const TeamCard({
    required this.team,
    this.coach,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<dynamic> users = team['users'] ?? [];
    final trainer = coach ?? users.firstWhere(
          (user) => user['type'] == 'TRAINER',
      orElse: () => null,
    );

    final traineeCount = users.where((user) => user['type'] == 'TRAINEE').length;

    return Card(
      child: ListTile(
        onTap: onTap,
        leading: const Icon(Icons.group),
        title: Text(team['name'] ?? 'Equipo'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (trainer != null)
              Text('Entrenador: ${trainer['name']}'),
            Text('Cantidad de jugadores: $traineeCount'),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
