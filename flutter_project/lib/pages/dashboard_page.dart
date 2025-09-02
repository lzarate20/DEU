import 'package:flutter/material.dart';
import 'package:flutter_project/pages/training_by_day_page.dart';

import '../services/team_service.dart';
import '../widgets/team_grid.dart';

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
    final theme = Theme.of(context).textTheme;

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
                child: Text(
                  'Mis Entrenamientos',
                  style: theme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(thickness: 2),
              const SizedBox(height: 8),

              Semantics(
                container: true,
                label: 'Listado de entrenamientos',
                child: const SizedBox(height: 560, child: TrainingPage()),
              ),

              const SizedBox(height: 24),

              Semantics(
                header: true,
                child: Text(
                  'Mis Equipos',
                  style: theme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
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
                  child: Text(
                    'No estás en ningún equipo.',
                    style: theme.bodyMedium,
                  ),
                )
              else
                Semantics(
                  container: true,
                  label: 'Listado de mis equipos',
                  child: TeamsGrid(teams: _teams),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
