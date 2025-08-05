import 'package:flutter/material.dart';
import 'package:flutter_project/services/exercise_service.dart';

class ExistingExerciseSelector extends StatefulWidget {
  final void Function(Map<String, dynamic>?) onSelected;

  const ExistingExerciseSelector({Key? key, required this.onSelected}) : super(key: key);

  @override
  _ExistingExerciseSelectorState createState() => _ExistingExerciseSelectorState();
}

class _ExistingExerciseSelectorState extends State<ExistingExerciseSelector> {
  Map<String, dynamic>? _selectedExercise;

  void _openExerciseSelectionModal() async {
    final selected = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Elegí un ejercicio existente'),
          content: FutureBuilder<List<Map<String, dynamic>>?>(
            future: ExerciseService().fetchExercises(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 100,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasError) {
                return const Text('Error al cargar ejercicios');
              }

              final exercises = snapshot.data;
              if (exercises == null || exercises.isEmpty) {
                return const Text('No se encontraron ejercicios');
              }

              return SizedBox(
                width: double.maxFinite,
                height: 400,
                child: ListView.builder(
                  itemCount: exercises.length,
                  itemBuilder: (context, index) {
                    final ex = exercises[index];
                    return ListTile(
                      title: Text(ex['name'] ?? 'Sin nombre'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (ex['description'] != null) Text(ex['description']),
                          Text('Tipo: ${_getTypeLabel(ex['type'])}'),
                          Text('Categoría: ${_getCategoryLabel(ex['category'])}'),
                        ],
                      ),
                      trailing: ex['video'] != null && ex['video']['url'] != null
                          ? const Icon(Icons.play_circle_fill, color: Colors.green)
                          : null,
                      isThreeLine: true,
                      onTap: () => Navigator.pop(context, ex),
                    );
                  },
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );

    if (selected != null) {
      setState(() => _selectedExercise = selected);
      widget.onSelected(selected);
    }
  }

  String _getTypeLabel(String? type) {
    return switch (type) {
      'REPETITION' => 'Repeticiones',
      'DURATION' => 'Duración',
      _ => 'Desconocido',
    };
  }

  String _getCategoryLabel(String? category) {
    return switch (category) {
      'WARMUP' => 'Calentamiento',
      'TRAINING' => 'Entrenamiento',
      'RECOVERY' => 'Recuperación',
      _ => 'Desconocida',
    };
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
          const Text('Ejercicio seleccionado:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _ReadOnlyExerciseDetails(exercise: _selectedExercise!),
        ],
      ],
    );
  }
}

class _ReadOnlyExerciseDetails extends StatelessWidget {
  final Map<String, dynamic> exercise;

  const _ReadOnlyExerciseDetails({Key? key, required this.exercise}) : super(key: key);

  String _getTypeLabel(String? type) {
    return switch (type) {
      'REPETITION' => 'Repeticiones',
      'DURATION' => 'Duración',
      _ => 'Desconocido',
    };
  }

  String _getCategoryLabel(String? category) {
    return switch (category) {
      'WARMUP' => 'Calentamiento',
      'TRAINING' => 'Entrenamiento',
      'RECOVERY' => 'Recuperación',
      _ => 'Desconocida',
    };
  }

  @override
  Widget build(BuildContext context) {
    final videoUrl = exercise['video']?['url'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          initialValue: exercise['name'] ?? '',
          decoration: const InputDecoration(labelText: 'Nombre'),
          readOnly: true,
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: exercise['description'] ?? '',
          decoration: const InputDecoration(labelText: 'Descripción'),
          readOnly: true,
          maxLines: 3,
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: _getTypeLabel(exercise['type']),
          decoration: const InputDecoration(labelText: 'Tipo'),
          readOnly: true,
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: _getCategoryLabel(exercise['category']),
          decoration: const InputDecoration(labelText: 'Categoría'),
          readOnly: true,
        ),
        const SizedBox(height: 8),
        if (exercise['type'] == 'DURATION')
          TextFormField(
            initialValue: '${exercise['time'] ?? 0} ${exercise['units'] ?? ''}',
            decoration: const InputDecoration(labelText: 'Duración'),
            readOnly: true,
          )
        else if (exercise['type'] == 'REPETITION')
          TextFormField(
            initialValue: '${exercise['count'] ?? 0} repeticiones',
            decoration: const InputDecoration(labelText: 'Cantidad'),
            readOnly: true,
          ),
        const SizedBox(height: 8),
        if (videoUrl != null && videoUrl.toString().isNotEmpty)
          TextFormField(
            initialValue: videoUrl,
            decoration: const InputDecoration(labelText: 'URL del video'),
            readOnly: true,
          ),
      ],
    );
  }
}


