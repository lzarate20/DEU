import 'package:flutter/material.dart';
import 'package:flutter_project/pages/training_page.dart';
import 'package:go_router/go_router.dart';

import '../services/team_service.dart';
import '../widgets/accesible_list.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final TeamService _teamService = TeamService();
  List<Map<String, dynamic>> _teams = [];
  bool _loadingTeams = true;

  @override
  void initState() {
    super.initState();
    _loadTeams();
  }

  Future<void> _loadTeams() async {
    final teams = await _teamService.fetchMyTeams();
    setState(() {
      _teams = teams ?? [];
      _loadingTeams = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Semantics(
          container: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                header: true,
                child: const Text(
                  'Mis Entrenamientos',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(thickness: 2),
              const SizedBox(height: 8),

              Semantics(
                container: true,
                label: 'Sección de entrenamientos',
                child: SizedBox(
                  height: 560,
                  child: const TrainingPage(),
                ),
              ),

              const SizedBox(height: 24),

              Semantics(
                header: true,
                child: const Text(
                  'Mis Equipos',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(thickness: 2),

              if (_loadingTeams)
                Semantics(
                  label: 'Cargando equipos',
                  child: const Center(child: CircularProgressIndicator()),
                )
              else if (_teams.isEmpty)
                Semantics(
                  label: 'No estás en ningún equipo',
                  child: const Text('No estás en ningún equipo.'),
                )
              else
                AccessibleList(
                  semanticsLabel: 'Lista de mis equipos',
                  buttons: _teams.map((team) {
                    final users = team['users'] as List<dynamic>? ?? [];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          team['name'] ?? 'Equipo',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        Text('${users.length} miembros', style: const TextStyle(color: Colors.black)),
                      ],
                    );
                  }).toList(),
                  onPressedCallbacks: _teams.map((team) {
                    return () {
                      context.go('/team/${team['id']}', extra: team);
                    };
                  }).toList(),
                )
            ],
          ),
        ),
      ),
    );
  }
}



