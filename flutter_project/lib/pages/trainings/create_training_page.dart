import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

import '../../services/auth_service.dart';
import '../../services/training_service.dart';
import '../../widgets/forms/exercise/exercise_form.dart';
import '../../widgets/forms/exercise/exercise_list_form.dart';
import '../../widgets/forms/training_form.dart';

class CreateTrainingPage extends StatefulWidget {
  const CreateTrainingPage({super.key});

  @override
  State<CreateTrainingPage> createState() => _CreateTrainingPageState();
}

class _CreateTrainingPageState extends State<CreateTrainingPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  DateTime? _selectedDate;
  String _trainingType = 'DRIBBLING';

  final List<String> _trainingTypes = ['DRIBBLING', 'SPEED', 'STRENGTH'];
  final Map<String, String> trainingTypeLabels = {
    'DRIBBLING': 'Regate',
    'SPEED': 'Velocidad',
    'STRENGTH': 'Fuerza',
  };

  final List<GlobalKey<ExerciseFormState>> _exerciseFormKeys = [];

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _addExerciseForm() {
    setState(() => _exerciseFormKeys.add(GlobalKey<ExerciseFormState>()));
  }

  void _removeExerciseForm(GlobalKey<ExerciseFormState> key) {
    setState(() => _exerciseFormKeys.remove(key));
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Revisá los campos del entrenamiento.')),
      );
      return;
    }

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Seleccioná una fecha para el entrenamiento.')),
      );
      return;
    }

    if (_exerciseFormKeys.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agregá al menos un ejercicio.')),
      );
      return;
    }

    List<Map<String, dynamic>> exercisesData = [];


    bool hasInvalidExercise = false;

    for (final key in _exerciseFormKeys) {
      final data = key.currentState?.saveIfValid();
      if (data != null) {
        final hasId = data['id'] != null;
        final exercise = data['exercise'];
        final hasValidExercise = exercise != null && (exercise['name']?.isNotEmpty ?? false);

        if (hasId || hasValidExercise) {
          exercisesData.add(data);
        } else {
          hasInvalidExercise = true;
        }
      }
      else{
        hasInvalidExercise = true;
      }
    }

    if (hasInvalidExercise) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Revisá los ejercicios: alguno está vacío o incompleto.")),
      );
      return;
    }

    final userIdStr = await AuthService.getLoggedUserId();
    final userId = int.tryParse(userIdStr ?? '');
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID de usuario inválido')),
      );
      return;
    }

    final training = {
      "name": _nameCtrl.text,
      "description": _descCtrl.text,
      "trainer": {"id": userId},
      "date": _selectedDate!.toIso8601String().split("T").first,
      "trainingType": _trainingType,
      "exercises": exercisesData,
    };

    final success = await TrainingService().createTraining(training);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Entrenamiento creado')),
      );
      if (context.mounted) context.go('/trainings');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al crear entrenamiento')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Semantics(
          header: true,
          child: Text(
            'Nuevo entrenamiento',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form( // 👈 un solo Form global
          key: _formKey,
          child: ListView(
            children: [
              TrainingForm(
                formKey: _formKey,
                nameCtrl: _nameCtrl,
                descCtrl: _descCtrl,
                dateCtrl: _dateCtrl,
                selectedDate: _selectedDate,
                onPickDate: _pickDate,
                trainingType: _trainingType,
                onTrainingTypeChanged: (val) => setState(() => _trainingType = val),
                trainingTypes: _trainingTypes,
                trainingTypeLabels: trainingTypeLabels,
              ),
              const SizedBox(height: 24),
              ExerciseListForm(
                exerciseFormKeys: _exerciseFormKeys,
                onRemove: _removeExerciseForm,
                onAdd: _addExerciseForm,
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerLeft,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: ElevatedButton(
                    onPressed: _submit,
                    child: const Text("Crear entrenamiento"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}


