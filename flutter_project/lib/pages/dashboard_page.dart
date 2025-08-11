import 'package:flutter/material.dart';
import 'package:flutter_project/pages/training_page.dart';
import 'package:go_router/go_router.dart';

import '../services/team_service.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final TeamService _teamService = TeamService();
  List<Map<String, dynamic>>? _teams;
  bool _loadingTeams = true;

  @override
  void initState() {
    super.initState();
    _loadTeams();
  }

  Future<void> _loadTeams() async {
    final teams = await _teamService.fetchTeams();
    setState(() {
      _teams = teams;
      _loadingTeams = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mis Entrenamientos',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Divider(thickness: 2),
            const SizedBox(height: 8),

            SizedBox(
              height: 560,
              child: const TrainingPage(),
            ),

            const SizedBox(height: 24),

            const Text(
              'Mis Equipos',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Divider(thickness: 2),

            if (_loadingTeams)
              const Center(child: CircularProgressIndicator())
            else if (_teams == null || _teams!.isEmpty)
              const Text('No estás en ningún equipo.')
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _teams!.length,
                itemBuilder: (context, index) {
                  final team = _teams![index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: InkWell(
                      mouseCursor: SystemMouseCursors.click,
                      onTap: () {
                        context.go('/team/${team['id']}', extra: team);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              team['name'] ?? 'Equipo',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text('${(team['users'] as List).length} miembros'),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

          ],
        ),
      ),
    );
  }
}

