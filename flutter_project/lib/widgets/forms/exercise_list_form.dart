import 'package:flutter/material.dart';
import 'exercise_form.dart';

class ExerciseListForm extends StatelessWidget {
  final List<GlobalKey<ExerciseFormState>> exerciseFormKeys;
  final void Function(GlobalKey<ExerciseFormState>) onRemove;
  final VoidCallback onAdd;

  const ExerciseListForm({
    super.key,
    required this.exerciseFormKeys,
    required this.onRemove,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Ejercicios:", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ...exerciseFormKeys.map((key) => ExerciseForm(
          key: key,
          onSaved: (_) {},
          onRemove: () => onRemove(key),
        )),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ElevatedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text("Agregar ejercicio"),
          ),
        ),
      ],
    );
  }
}
