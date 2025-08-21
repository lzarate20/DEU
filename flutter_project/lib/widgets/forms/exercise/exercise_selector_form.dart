import 'package:flutter/material.dart';
import 'package:flutter_project/widgets/forms/exercise/read_only_exercise_details.dart';

import 'exercise_selection_modal.dart';

class ExistingExerciseSelector extends StatefulWidget {
  final void Function(Map<String, dynamic>?) onSelected;

  const ExistingExerciseSelector({Key? key, required this.onSelected})
    : super(key: key);

  @override
  _ExistingExerciseSelectorState createState() =>
      _ExistingExerciseSelectorState();
}

class _ExistingExerciseSelectorState extends State<ExistingExerciseSelector> {
  Map<String, dynamic>? _selectedExercise;

  void _openExerciseSelectionModal() async {
    final selected = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => ExerciseSelectionModal(),
    );

    if (selected != null) {
      setState(() => _selectedExercise = selected);
      widget.onSelected(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton.icon(
          onPressed: _openExerciseSelectionModal,
          icon: const Icon(Icons.search),
          label: const Text('Seleccionar ejercicio existente'),
        ),
        if (_selectedExercise != null) ...[
          const SizedBox(height: 12),
          const Text(
            'Ejercicio seleccionado:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ReadOnlyExerciseDetails(exercise: _selectedExercise!),
        ],
      ],
    );
  }
}
