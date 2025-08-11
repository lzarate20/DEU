import 'package:flutter/material.dart';
import '../../services/team_service.dart';

class TeamDetailPage extends StatefulWidget {
  final String teamId;
  final Map<String, dynamic>? team;

  const TeamDetailPage({
    super.key,
    required this.teamId,
    this.team,
  });

  @override
  State<TeamDetailPage> createState() => _TeamDetailPageState();
}

class _TeamDetailPageState extends State<TeamDetailPage> {
  Map<String, dynamic>? _team;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    if (widget.team != null) {
      _team = widget.team;
      _loading = false;
    } else {
      _fetchTeam();
    }
  }

  Future<void> _fetchTeam() async {
    final service = TeamService();
    final data = await service.fetchTeamById(widget.teamId);
    setState(() {
      _team = data;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_team == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Equipo no encontrado")),
        body: const Center(child: Text("No se encontró la información del equipo.")),
      );
    }

    final List<dynamic> users = _team!['users'] ?? [];
    final trainer = users.firstWhere(
          (user) => user['type'] == 'TRAINER',
      orElse: () => null,
    );
    final players = users.where((u) => u['type'] == 'TRAINEE').toList();

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            _team!['name'] ?? 'Equipo',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
        toolbarHeight: 80,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Columna izquierda: descripción + jugadores
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Descripción del equipo",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _team!['description'] ??
                        'Este es un gran equipo comprometido con el entrenamiento y la mejora continua.',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),

                  // El listado de jugadores con scroll ocupa el espacio restante
                  Expanded(
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Jugadores",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                                  : const Center(
                                child: Text('No hay jugadores asignados.'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 20),

            Expanded(
              flex: 1,
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Entrenador",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      const Divider(thickness: 2, height: 20),
                      if (trainer != null)
                        ListTile(
                          leading: const Icon(Icons.sports),
                          title: Text(trainer['name'] ?? 'Desconocido'),
                          subtitle: Text(trainer['email'] ?? ''),
                        )
                      else
                        const Text("No se encontró entrenador asignado."),
                      Expanded(child: Container()),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }
}

