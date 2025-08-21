import 'package:flutter/material.dart';
import 'package:flutter_project/pages/teams/team_card.dart';
import 'package:go_router/go_router.dart';

import '../../configProject/global_config.dart';
import '../../services/team_service.dart';
import '../../services/user_service.dart';
import '../../widgets/search_filter.dart';

class TeamListPage extends StatefulWidget {
  const TeamListPage({super.key});

  @override
  State<TeamListPage> createState() => _TeamListPageState();
}

class _TeamListPageState extends State<TeamListPage> with RouteAware {
  final TeamService _teamService = TeamService();
  final UserService _userService = UserService();

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<Map<String, dynamic>> _teams = [];
  List<Map<String, dynamic>> _users = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void dispose() {
    _searchController.dispose();
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    _loadData();
  }

  Future<void> _loadData() async {
    final teams = await _teamService.fetchTeams() ?? [];
    final users = await _userService.fetchUsers();
    setState(() {
      _teams = teams;
      _users = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredTeams = _teams.where((team) {
      final name = (team['name'] ?? '').toString().toLowerCase();
      final users = List<Map<String, dynamic>>.from(team['users'] ?? []);
      final coach = users.firstWhere(
            (user) => user['type'] == 'TRAINER',
        orElse: () => {'name': ''},
      );
      final coachName = (coach['name'] ?? '').toString().toLowerCase();

      return _searchQuery.isEmpty ||
          name.contains(_searchQuery) ||
          coachName.contains(_searchQuery);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Equipos')),
      body: Column(
        children: [
          SearchFilters(
            controller: _searchController,
            onSearch: (value) {
              setState(() {
                _searchQuery = value.toLowerCase();
              });
            },
            showDateFilters: false,
            hintText: 'Buscar por nombre o entrenador',
          ),
          Expanded(
            child: _teams.isEmpty || _users.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : filteredTeams.isEmpty
                ? const Center(child: Text('No hay equipos disponibles.'))
                : ListView.builder(
              itemCount: filteredTeams.length,
              itemBuilder: (context, index) {
                final team = filteredTeams[index];
                final users =
                List<Map<String, dynamic>>.from(team['users'] ?? []);
                final coach = users.firstWhere(
                      (user) => user['type'] == 'TRAINER',
                  orElse: () => {'name': 'Desconocido'},
                );

                return TeamCard(
                  team: team,
                  coach: coach,
                  onTap: () {
                    context.go('/team/${team['id']}', extra: team);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final TextEditingController _controller = TextEditingController();

          final result = await showDialog<String>(
            context: context,
            builder: (BuildContext context) {
              final theme = Theme.of(context);
              return AlertDialog(
                title: Semantics(
                  header: true,
                  child: Text(
                    'Crear nuevo equipo',
                    style: theme.textTheme.headlineMedium,
                  ),
                ),
                content: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: 'Nombre del equipo',
                    labelStyle: theme.textTheme.bodyMedium,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancelar', style: theme.textTheme.bodyMedium),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, _controller.text.trim());
                    },
                    child: Text('Guardar', style: theme.textTheme.bodyMedium),
                  ),
                ],
              );
            },
          );

          if (result != null && result.isNotEmpty) {
            await TeamService().createTeam(result);
            _loadData();
          }
        },
        child: const Icon(Icons.add),
        tooltip: 'Crear nuevo equipo',
      ),
    );
  }
}


