import 'package:flutter/material.dart';

import '../../../services/exercise_service.dart';
import '../../search_filter.dart';
import 'exercise_list_item.dart';

class ExerciseSelectionModal extends StatefulWidget {
  @override
  State<ExerciseSelectionModal> createState() => _ExerciseSelectionModalState();
}

class _ExerciseSelectionModalState extends State<ExerciseSelectionModal> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _exercises = [];
  List<Map<String, dynamic>> _filteredExercises = [];

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    final data = await ExerciseService().fetchExercises();
    setState(() {
      _exercises = data ?? [];
      _filteredExercises = List.from(_exercises);
    });
  }

  void _onSearch(String query) {
    final lowerQuery = query.toLowerCase();

    final typeMap = {
      'calentamiento': 'WARMUP',
      'entrenamiento': 'TRAINING',
      'recuperacion': 'RECOVERY',
      'recuperación': 'RECOVERY',
    };

    setState(() {
      _filteredExercises = _exercises.where((ex) {
        final name = (ex['name'] ?? '').toString().toLowerCase();
        final type = (ex['category'] ?? '').toString().toLowerCase();

        final matchesName = name.contains(lowerQuery);

        final matchesType = typeMap.entries.any(
                (entry) => entry.value.toLowerCase() == type && entry.key.contains(lowerQuery)
        );

        return matchesName || matchesType;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Elegí un ejercicio existente'),
      content: SizedBox(
        width: double.maxFinite,
        height: 450,
        child: _exercises.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            SearchFilters(
              controller: _searchController,
              onSearch: _onSearch,
              showDateFilters: false,
              hintText: 'Buscar por nombre o tipo',
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _filteredExercises.isEmpty
                  ? const Center(child: Text('No se encontraron ejercicios'))
                  : ListView.builder(
                itemCount: _filteredExercises.length,
                itemBuilder: (context, index) {
                  final ex = _filteredExercises[index];
                  return ExerciseListItem(
                    exercise: ex,
                    onTap: () => Navigator.pop(context, ex),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}


