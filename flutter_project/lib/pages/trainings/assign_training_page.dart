import 'package:flutter/material.dart';
import 'package:flutter_project/services/team_service.dart';
import 'package:flutter_project/services/user_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

import '../../services/auth_service.dart';
import '../../services/training_service.dart';

class AssignTrainingPage extends StatefulWidget {
  final int trainingId;
  final Map<String, dynamic>? training;

  const AssignTrainingPage({
    super.key,
    required this.trainingId,
    this.training,
  });

  @override
  State<AssignTrainingPage> createState() => _AssignTrainingPageState();
}

class _AssignTrainingPageState extends State<AssignTrainingPage> {

  late Map<String, dynamic> training;
  List<Map<String, dynamic>> allTrainees = [];
  Map<String, bool> selectedPlayers = {};
  Map<String, bool> hasTraining = {};
  Set<String> selectedPositions = {};

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.training != null) {
      training = widget.training!;
      _fetchTrainingAndLoadTrainees();
    } else {
      _fetchTrainingById();
    }
  }

  Future<void> _fetchTrainingById() async {
    setState(() => isLoading = true);
    final trainingData = await TrainingService().fetchTrainingById(widget.trainingId.toString());
    if (trainingData != null) {
      training = trainingData;
      _fetchTrainingAndLoadTrainees();
    } else {
      setState(() => isLoading = false);
    }
  }

  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  final Map<String, String> positionTranslations = {
    'DEFENCE': 'Defensa',
    'MIDFIELD': 'Mediocampo',
    'FORWARD': 'Delantero',
    'Sin posición': 'Sin posición',
  };

  Future<void> _fetchTrainingAndLoadTrainees() async {
    final trainingId = training['id'].toString();
    if (trainingId.isEmpty) return;

    final existingTraineeIds = (training['trainees'] as List)
        .map((e) => e.toString())
        .toSet();

    await _loadAllTraineesFromAllTeams();

    setState(() {
      for (final trainee in allTrainees) {
        final id = trainee['id'].toString();
        final alreadyHas = existingTraineeIds.contains(id);
        hasTraining[id] = alreadyHas;
        selectedPlayers[id] = !alreadyHas;
      }
    });
  }

  Future<void> _loadAllTraineesFromAllTeams() async {
    setState(() {
      isLoading = true;
      allTrainees = [];
      selectedPlayers.clear();
      hasTraining.clear();
      searchController.clear();
      searchQuery = '';
      selectedPositions.clear();
    });

    final userId = await AuthService.getLoggedUserId();
    final teams = await UserService().fetchUserTeams(userId.toString());

    final uniqueTrainees = <String, Map<String, dynamic>>{};

    for (final team in teams) {
      final teamData = await TeamService().fetchTeamById(team['id'].toString());
      if (teamData != null && teamData['users'] != null) {
        final users = List<Map<String, dynamic>>.from(teamData['users']);
        for (final user in users) {
          if (user['type'] == 'TRAINEE') {
            uniqueTrainees[user['id'].toString()] = user;
          }
        }
      }
    }

    final trainingId = int.tryParse(training['id'].toString());

    setState(() {
      allTrainees = uniqueTrainees.values.toList();
      for (final trainee in allTrainees) {
        final id = trainee['id'].toString();

        final trainings = (trainee['trainings'] ?? []) as List;
        final alreadyHas =
            trainingId != null &&
            trainings.any(
              (t) => int.tryParse(t['id'].toString()) == trainingId,
            );

        hasTraining[id] = alreadyHas;
        selectedPlayers[id] = !alreadyHas;
      }
      isLoading = false;
    });
  }

  List<Map<String, dynamic>> get filteredTrainees {
    var filtered = allTrainees;

    if (selectedPositions.isNotEmpty) {
      filtered = filtered
          .where(
            (u) => selectedPositions.contains(
              positionTranslations[u['position']] ?? 'Sin posición',
            ),
          )
          .toList();
    }

    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((u) {
        final name = (u['name'] ?? '').toLowerCase();
        return name.contains(searchQuery);
      }).toList();
    }

    return filtered;
  }

  void _onSearchChanged(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
    });
  }

  void _toggleSelectAllVisible() {
    final visibles = filteredTrainees
        .where((u) => !(hasTraining[u['id'].toString()] ?? false))
        .toList();
    final allSelected = visibles.every(
      (u) => selectedPlayers[u['id'].toString()] ?? false,
    );

    setState(() {
      for (final player in visibles) {
        selectedPlayers[player['id'].toString()] = !allSelected;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final allPositions = allTrainees
        .map((u) => positionTranslations[u['position']] ?? 'Sin posición')
        .toSet();

    final visibles = filteredTrainees;
    final visiblesSeleccionables = visibles
        .where((u) => !(hasTraining[u['id'].toString()] ?? false))
        .toList();

    final allVisibleSelected = visiblesSeleccionables.isNotEmpty &&
        visiblesSeleccionables
            .every((u) => selectedPlayers[u['id'].toString()] ?? false);



    return Scaffold(
      appBar: AppBar(title: Semantics( header: true, child: Text( 'Asignar entrenamiento', style: Theme.of(context).textTheme.headlineMedium, ), )),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Buscar jugadores por nombre',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _onSearchChanged,
            ),
            const SizedBox(height: 16),
            if (allTrainees.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Filtrar por posición',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Wrap(
                    spacing: 8,
                    children: allPositions.map((pos) {
                      final isSelected = selectedPositions.contains(pos);
                      return FilterChip(
                        label: Text(pos),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              selectedPositions.add(pos);
                            } else {
                              selectedPositions.remove(pos);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            if (isLoading)
              Center(child: CircularProgressIndicator())
            else if (!isLoading && visibles.isEmpty)
              Text('No hay jugadores para mostrar')
            else ...[
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    icon: Icon(
                      allVisibleSelected ? Icons.remove_circle_outline : Icons.select_all,
                    ),
                    label: Text(
                      allVisibleSelected ? 'Deseleccionar todos' : 'Seleccionar todos',
                    ),
                    onPressed: visiblesSeleccionables.isEmpty ? null : _toggleSelectAllVisible,
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: visibles.length,
                  itemBuilder: (_, index) {
                    final player = visibles[index];
                    final playerId = player['id'].toString();
                    final isSelected = selectedPlayers[playerId] ?? false;
                    final alreadyHas = hasTraining[playerId] ?? false;

                    return Container(
                      color: alreadyHas ? Colors.grey[200] : null,
                      child: ListTile(
                        leading: Icon(
                          Icons.person,
                          color: alreadyHas ? Colors.grey : null,
                        ),
                        title: Text(
                          player['name'],
                          style: TextStyle(
                            color: alreadyHas ? Colors.grey : null,
                          ),
                        ),
                        subtitle: Text(
                          positionTranslations[player['position']] ??
                              'Sin posición',
                          style: TextStyle(
                            color: alreadyHas ? Colors.grey : null,
                          ),
                        ),
                        trailing: alreadyHas
                            ? Text(
                                'Ya tiene este entrenamiento',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic,
                                ),
                              )
                            : Icon(
                                isSelected
                                    ? Icons.check_circle
                                    : Icons.check_circle_outline,
                                color: isSelected ? Colors.green : Colors.grey,
                              ),
                        onTap: alreadyHas
                            ? null
                            : () {
                                setState(() {
                                  selectedPlayers[playerId] = !isSelected;
                                });
                              },
                      ),
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: selectedPlayers.values.any((v) => v)
                    ? _assignTraining
                    : null,
                child: Text('Asignar Entrenamiento'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _assignTraining() async {
    final selectedIds = selectedPlayers.entries
        .where((e) => e.value)
        .map((e) => int.tryParse(e.key))
        .whereType<int>()
        .toList();

    final success = await UserService().assignTrainingToUsers(
      widget.trainingId,
      selectedIds,
    );

    if (success) {
      context.go('/trainings');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo asignar el entrenamiento')),
      );
    }
  }
}
