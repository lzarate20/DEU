import 'package:flutter/material.dart';

import 'exercise_selector_form.dart';

class ExerciseForm extends StatefulWidget {
  final void Function(Map<String, dynamic>) onSaved;
  final void Function()? onRemove;

  const ExerciseForm({super.key, required this.onSaved, this.onRemove});

  @override
  State<ExerciseForm> createState() => ExerciseFormState();
}

class ExerciseFormState extends State<ExerciseForm> {
  final _formKey = GlobalKey<FormState>();
  final _existingIdCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _timeCtrl = TextEditingController();
  final _countCtrl = TextEditingController(text: "1");
  final _urlCtrl = TextEditingController();

  bool _useExisting = false;
  String _type = 'REPETITION';
  String _units = 'SEC';
  String _category = 'Entrenamiento';

  final Map<String, String> _categoryMap = {
    'Calentamiento': 'WARMUP',
    'Entrenamiento': 'TRAINING',
    'Recuperación': 'RECOVERY',
  };

  final List<String> _categories = [
    'Calentamiento',
    'Entrenamiento',
    'Recuperación',
  ];

  final List<String> _types = ['REPETITION', 'DURATION'];

  final List<Map<String, String>> _unitOptions = [
    {'label': 'Segundos', 'value': 'SEC'},
    {'label': 'Minutos', 'value': 'MIN'},
    {'label': 'Horas', 'value': 'HOUR'},
  ];


  Map<String, dynamic>? saveIfValid() {
    if (_useExisting) {
      final id = int.tryParse(_existingIdCtrl.text);
      if (id != null) {
        return {"id": id}; // Devuelve como ExerciseTrainingSaveDTO con solo ID
      } else {
        return null;
      }
    }

    if (_formKey.currentState!.validate()) {
      final exercise = {
        "name": _nameCtrl.text,
        "description": _descCtrl.text,
        "type": _type,
        "category": _categoryMap[_category],
        "isVisible": true,
        "count": _type == 'REPETITION'
            ? int.tryParse(_countCtrl.text) ?? 1
            : 1,
      };

      if (_type == 'DURATION') {
        exercise["time"] = int.tryParse(_timeCtrl.text) ?? 0;
        exercise["units"] = _units;
      }

      if (_urlCtrl.text.isNotEmpty) {
        exercise["url"] = _urlCtrl.text;
      }

      return {
        "exercise": exercise  // Devuelve como ExerciseTrainingSaveDTO con el campo "exercise"
      };
    }

    return null;
  }

  void _openVideoSelectorModal() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Seleccionar video"),
        content: const Text("Aquí se mostraría un listado de videos cargados"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cerrar"),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactField({required Widget child}) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 500),
      child: child,
    );
  }

  void _openExistingExerciseModal() async {

    final selectedId = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Elegí un ejercicio existente"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("Push-ups (ID: 1)"),
              onTap: () => Navigator.pop(context, 1),
            ),
            ListTile(
              title: const Text("Squats (ID: 2)"),
              onTap: () => Navigator.pop(context, 2),
            ),
            ListTile(
              title: const Text("Sit-ups (ID: 3)"),
              onTap: () => Navigator.pop(context, 3),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
        ],
      ),
    );

    if (selectedId != null) {
      setState(() => _existingIdCtrl.text = selectedId.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Nuevo ejercicio", style: TextStyle(fontWeight: FontWeight.bold)),
                  if (widget.onRemove != null)
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: widget.onRemove,
                    )
                ],
              ),
              Row(
                children: [
                  ChoiceChip(
                    label: const Text("Usar existente"),
                    selected: _useExisting,
                    onSelected: (_) => setState(() => _useExisting = true),
                  ),
                  const SizedBox(width: 10),
                  ChoiceChip(
                    label: const Text("Crear nuevo"),
                    selected: !_useExisting,
                    onSelected: (_) => setState(() => _useExisting = false),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              if (_useExisting)
                ExistingExerciseSelector(
                  onSelected: (exercise) {
                    setState(() {
                      if (exercise != null) {
                        _existingIdCtrl.text = exercise['id'].toString();
                        // Opcional: guardar también otros campos para mostrar en el form, pero solo lectura
                        _nameCtrl.text = exercise['name'] ?? '';
                        _descCtrl.text = exercise['description'] ?? '';
                      } else {
                        _existingIdCtrl.text = '';
                        _nameCtrl.text = '';
                        _descCtrl.text = '';
                      }
                    });
                  },
                ),

              // Modo: Crear nuevo
              if (!_useExisting) ...[
                _buildCompactField(
                  child: TextFormField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(labelText: "Nombre"),
                    validator: _required,
                  ),
                ),
                const SizedBox(height: 10),
                _buildCompactField(
                  child: TextFormField(
                    controller: _descCtrl,
                    maxLines: 3,
                    decoration: const InputDecoration(labelText: "Descripción"),
                    validator: _required,
                  ),
                ),
                const SizedBox(height: 10),

                const Text("Tipo", style: TextStyle(fontWeight: FontWeight.w500)),
                Wrap(
                  spacing: 8,
                  children: _types.map((t) {
                    final label = t == 'REPETITION' ? 'Repeticiones' : 'Duración';
                    return ChoiceChip(
                      label: Text(label),
                      selected: _type == t,
                      onSelected: (_) => setState(() => _type = t),
                    );
                  }).toList(),
                ),

                if (_type == 'DURATION') ...[
                  const SizedBox(height: 12),
                  _buildCompactField(
                    child: TextFormField(
                      controller: _timeCtrl,
                      decoration: const InputDecoration(labelText: "Tiempo"),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text("Unidad", style: TextStyle(fontWeight: FontWeight.w500)),
                  Wrap(
                    spacing: 8,
                    children: _unitOptions.map((u) {
                      return ChoiceChip(
                        label: Text(u['label']!),
                        selected: _units == u['value'],
                        onSelected: (_) => setState(() => _units = u['value']!),
                      );
                    }).toList(),
                  ),
                ],

                if (_type == 'REPETITION') ...[
                  const SizedBox(height: 10),
                  _buildCompactField(
                    child: TextFormField(
                      controller: _countCtrl,
                      decoration: const InputDecoration(labelText: "Cantidad de veces a realizar"),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],

                const SizedBox(height: 12),
                const Text("Categoría", style: TextStyle(fontWeight: FontWeight.w500)),
                Wrap(
                  spacing: 8,
                  children: _categories.map((cat) {
                    return ChoiceChip(
                      label: Text(cat),
                      selected: _category == cat,
                      onSelected: (_) => setState(() => _category = cat),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 12),
                _buildCompactField(
                  child: TextFormField(
                    controller: _urlCtrl,
                    decoration: const InputDecoration(labelText: "URL del video (opcional)"),
                  ),
                ),

                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton.icon(
                    onPressed: _openVideoSelectorModal,
                    icon: const Icon(Icons.video_library),
                    label: const Text("Importar desde biblioteca"),
                  ),
                ),
              ],

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  String? _required(String? value) =>
      value == null || value.isEmpty ? 'Campo obligatorio' : null;
}






