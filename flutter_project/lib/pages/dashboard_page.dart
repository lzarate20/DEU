import 'package:flutter/material.dart';
import 'package:flutter_project/pages/training_page.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../services/team_service.dart';
import '../widgets/accesible_list.dart';
import '../widgets/theme_provider.dart';

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
    final color = context.watch<ThemeProvider>().textColor;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Semantics(
          container: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// --- Sección Entrenamientos ---
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
                label: 'Sección de entrenamientos',
                child: const SizedBox(
                  height: 560,
                  child: TrainingPage(),
                ),
              ),

              const SizedBox(height: 24),

              Semantics(
                header: true,
                child: Text(
                  'Mis Equipos',
                  style: theme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
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
                AccessibleList(
                  semanticsLabel: 'Lista de mis equipos',
                  buttons: _teams.map((team) {
                    final users = team['users'] as List<dynamic>? ?? [];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          team['name'] ?? 'Equipo',
                          style: theme.bodyLarge?.copyWith(
                            color: color
                          ),
                        ),
                        Text(
                          '${users.length} miembros',
                          style: theme.bodyMedium?.copyWith(color: color),
                        ),
                      ],
                    );
                  }).toList(),
                  onPressedCallbacks: _teams.map((team) {
                    return () {
                      context.go('/team/${team['id']}', extra: team);
                    };
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}




