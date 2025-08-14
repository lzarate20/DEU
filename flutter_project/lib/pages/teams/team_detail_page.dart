import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
    final data = await TeamService().fetchTeamById(widget.teamId);
    setState(() {
      _team = data;
      _loading = false;
    });
  }

  Future<void> _addCurrentUserToTeam() async {
    final userId = await FlutterSecureStorage().read(key: 'user_id');
    if (userId != null && _team != null) {
      final success = await TeamService().addUserToTeam(
        _team!['id'].toString(),
        userId,
      );
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Te sumaste al equipo!')),
        );
        _fetchTeam(); // recarga los datos
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo sumar al equipo.')),
        );
      }
    }
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

                  // Listado de jugadores con botón sumarse
                  Expanded(
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FutureBuilder<String?>(
                              future:
                              FlutterSecureStorage().read(key: 'user_id'),
                              builder: (context, snapshot) {
                                final currentUserId = snapshot.data;
                                final alreadyInTeam = currentUserId != null &&
                                    players.any((p) =>
                                    p['id'].toString() ==
                                        currentUserId);

                                return Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Jugadores",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.person_add,
                                        color: alreadyInTeam
                                            ? Colors.grey
                                            : Colors.green,
                                      ),
                                      tooltip: alreadyInTeam
                                          ? 'Ya estás en el equipo'
                                          : 'Sumarse al equipo',
                                      onPressed: alreadyInTeam
                                          ? null
                                          : _addCurrentUserToTeam,
                                    ),
                                  ],
                                );
                              },
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
                                    subtitle: Text(
                                        player['position'] ?? 'Sin posición'),
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

            // Columna derecha: entrenador
            Expanded(
              flex: 1,
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Entrenador",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
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




