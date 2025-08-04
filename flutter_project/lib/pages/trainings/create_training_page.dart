import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../services/training_service.dart';
import '../../widgets/exercise/exercise_form.dart';

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

  final List<String> _trainingTypes = ['DRIBBLING', 'SPEED', 'STRENGHT'];

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
        _exerciseData.add({"exercise": data});
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
      Navigator.pop(context);
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
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: "Nombre del entrenamiento"),
                validator: (v) => v!.isEmpty ? "Campo obligatorio" : null,
              ),
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: "Descripción"),
                validator: (v) => v!.isEmpty ? "Campo obligatorio" : null,
              ),
              const SizedBox(height: 12),
              ListTile(
                title: Text(_selectedDate == null
                    ? "Seleccionar fecha"
                    : "Fecha: ${_selectedDate!.toLocal().toString().split(' ')[0]}"),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDate,
              ),
              const SizedBox(height: 16),
              const Text("Tipo de entrenamiento:", style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8,
                children: _trainingTypes.map((type) {
                  return ChoiceChip(
                    label: Text(type),
                    selected: _trainingType == type,
                    onSelected: (_) => setState(() => _trainingType = type),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              const Text("Ejercicios:", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ..._exerciseFormKeys.map((key) => ExerciseForm(
                key: key,
                onSaved: (_) {},
                onRemove: () => _removeExerciseForm(key),
              )),
              ElevatedButton.icon(
                onPressed: _addExerciseForm,
                icon: const Icon(Icons.add),
                label: const Text("Agregar ejercicio"),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                child: const Text("Crear entrenamiento"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


