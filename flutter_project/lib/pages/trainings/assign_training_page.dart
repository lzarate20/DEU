import 'package:flutter/material.dart';
import 'package:flutter_project/services/team_service.dart';
import 'package:flutter_project/services/user_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class AssignTrainingPage extends StatefulWidget {
  final Map<String, dynamic> training;

  const AssignTrainingPage({super.key, required this.training});

  @override
  State<AssignTrainingPage> createState() => _AssignTrainingPageState();
}

class _AssignTrainingPageState extends State<AssignTrainingPage> {
  static const _storage = FlutterSecureStorage();

  List<Map<String, dynamic>> allTrainees = [];
  Map<String, bool> selectedPlayers = {};
  Set<String> selectedPositions = {};

  bool isLoading = false;
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadAllTraineesFromAllTeams();
  }

  Future<void> _loadAllTraineesFromAllTeams() async {
    setState(() {
      isLoading = true;
      allTrainees = [];
      selectedPlayers.clear();
      searchController.clear();
      searchQuery = '';
      selectedPositions.clear();
    });

    final userId = await _storage.read(key: 'user_id');
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

    setState(() {
      allTrainees = uniqueTrainees.values.toList();
      for (final trainee in allTrainees) {
        selectedPlayers[trainee['id'].toString()] = true;
      }
      isLoading = false;
    });
  }

  List<Map<String, dynamic>> get filteredTrainees {
    var filtered = allTrainees;

    if (selectedPositions.isNotEmpty) {
      filtered = filtered
          .where((u) => selectedPositions.contains(u['position'] ?? 'Sin posición'))
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
    final visibles = filteredTrainees;
    final allSelected = visibles.every((u) => selectedPlayers[u['id'].toString()] ?? false);

    setState(() {
      for (final player in visibles) {
        selectedPlayers[player['id'].toString()] = !allSelected;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final allPositions = allTrainees.map((u) => u['position'] ?? 'Sin posición').toSet();
    final visibles = filteredTrainees;
    final allVisibleSelected =
        visibles.isNotEmpty && visibles.every((u) => selectedPlayers[u['id'].toString()] ?? false);

    return Scaffold(
      appBar: AppBar(title: Text('Asignar Entrenamiento')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔎 Barra de búsqueda
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

            // 🟢 Filtro de posición
            if (allTrainees.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Filtrar por posición', style: TextStyle(fontWeight: FontWeight.bold)),
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

            // ⏳ Loading / No jugadores / Lista
            if (isLoading)
              Center(child: CircularProgressIndicator())
            else if (!isLoading && visibles.isEmpty)
              Text('No hay jugadores para mostrar')
            else ...[
                // ✅ Botón seleccionar/deseleccionar todos
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    icon: Icon(allVisibleSelected ? Icons.remove_circle_outline : Icons.select_all),
                    label: Text(allVisibleSelected ? 'Deseleccionar todos' : 'Seleccionar todos'),
                    onPressed: _toggleSelectAllVisible,
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: visibles.length,
                    itemBuilder: (_, index) {
                      final player = visibles[index];
                      final playerId = player['id'].toString();
                      final isSelected = selectedPlayers[playerId] ?? false;

                      return ListTile(
                        leading: Icon(Icons.person),
                        title: Text(player['name']),
                        subtitle: Text(player['position'] ?? 'Sin posición'),
                        trailing: Icon(
                          isSelected ? Icons.check_circle : Icons.check_circle_outline,
                          color: isSelected ? Colors.green : Colors.grey,
                        ),
                        onTap: () {
                          setState(() {
                            selectedPlayers[playerId] = !isSelected;
                          });
                        },
                      );
                    },
                  ),
                ),
              ],

            const SizedBox(height: 16),

            Center(
              child: ElevatedButton(
                onPressed: selectedPlayers.values.any((v) => v) ? _assignTraining : null,
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
    print(selectedIds.toString());
    final trainingId = int.tryParse(widget.training['id']);
    if (trainingId is! int) {
      print("ID del entrenamiento inválido: $trainingId");
      return;
    }

    await UserService().assignTrainingToUsers(trainingId, selectedIds);
  }
}







