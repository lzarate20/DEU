import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import '../../services/training_service.dart';
import '../../widgets/forms/exercise_form.dart';
import '../../widgets/forms/exercise_list_form.dart';
import '../../widgets/forms/training_form.dart';

class CreateTrainingPage extends StatefulWidget {
  const CreateTrainingPage({super.key});

  @override
  State<CreateTrainingPage> createState() => _CreateTrainingPageState();
}

class _CreateTrainingPageState extends State<CreateTrainingPage> {
  final _secureStorage = const FlutterSecureStorage();

  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  DateTime? _selectedDate;
  String _trainingType = 'DRIBBLING';

  final List<String> _trainingTypes = ['DRIBBLING', 'SPEED', 'STRENGTH'];
  final Map<String, String> trainingTypeLabels = {
    'DRIBBLING': 'Regate',
    'SPEED': 'Velocidad',
    'STRENGTH': 'Fuerza',
  };

  final List<Map<String, dynamic>> _exerciseData = [];
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
    final key = GlobalKey<ExerciseFormState>();
    setState(() {
      _exerciseFormKeys.add(key);
    });
  }

  void _removeExerciseForm(GlobalKey<ExerciseFormState> key) {
    setState(() {
      _exerciseFormKeys.remove(key);
    });
  }

  Future<void> _submit() async {
    _exerciseData.clear();
    bool allValid = true;

    for (final key in _exerciseFormKeys) {
      final state = key.currentState;
      final data = state?.saveIfValid();
      if (data != null) {
        _exerciseData.add(data);
      } else {
        allValid = false;
      }
    }

    if (!allValid || !_formKey.currentState!.validate() || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Revisá los campos del entrenamiento y los ejercicios')),
      );
      return;
    }

    if (_exerciseData.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agrega al menos un ejercicio')),
      );
      return;
    }

    final userIdStr = await _secureStorage.read(key: 'user_id');
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
      "exercises": _exerciseData,
    };

    final success = await TrainingService().createTraining(training);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Entrenamiento creado')),
      );
      context.go('/trainings');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al crear entrenamiento')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nuevo Entrenamiento")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TrainingForm(
              formKey: _formKey,
              nameCtrl: _nameCtrl,
              descCtrl: _descCtrl,
              selectedDate: _selectedDate,
              onPickDate: _pickDate,
              trainingType: _trainingType,
              onTrainingTypeChanged: (val) => setState(() => _trainingType = val),
              trainingTypes: _trainingTypes,
              trainingTypeLabels: trainingTypeLabels,  // nuevo parámetro
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
    );
  }
}






