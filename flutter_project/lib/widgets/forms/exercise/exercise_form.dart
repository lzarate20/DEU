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

  final List<String> _types = ['REPETITION', 'TIME'];

  final List<Map<String, String>> _unitOptions = [
    {'label': 'Segundos', 'value': 'SEC'},
    {'label': 'Minutos', 'value': 'MIN'},
    {'label': 'Horas', 'value': 'HOUR'},
  ];


  Map<String, dynamic>? saveIfValid() {
    if (_useExisting) {
      final id = int.tryParse(_existingIdCtrl.text);
      if (id != null) {
        return {"id": id};
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Debés seleccionar un ejercicio existente.")),
        );
        return null;
      }
    }

    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor completá todos los campos requeridos.")),
      );
      return null;
    }

    _formKey.currentState!.save();

    final exercise = {
      "name": _nameCtrl.text,
      "description": _descCtrl.text,
      "type": _type,
      "category": _categoryMap[_category],
      "isVisible": true,
      "count": _type == 'REPETITION' ? int.tryParse(_countCtrl.text) ?? 1 : 1,
    };

    if (_type == 'TIME') {
      exercise["time"] = int.tryParse(_timeCtrl.text) ?? 0;
      exercise["units"] = _units;
    }

    if (_urlCtrl.text.isNotEmpty) {
      exercise["url"] = _urlCtrl.text;
    }

    return {"exercise": exercise};
  }



  void _openVideoSelectorModal() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Seleccionar video"),
        content: const Text("Aquí se mostraría un listado de videos cargados"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

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
                  Text(
                    "Nuevo ejercicio",
                    style: textTheme.titleSmall,
                  ),
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
                    label: Text("Usar existente", style: textTheme.bodyMedium),
                    selected: _useExisting,
                    onSelected: (_) => setState(() => _useExisting = true),
                  ),
                  const SizedBox(width: 10),
                  ChoiceChip(
                    label: Text("Crear nuevo", style: textTheme.bodyMedium),
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

              if (!_useExisting) ...[
                _buildCompactField(
                  child: TextFormField(
                    controller: _nameCtrl,
                    decoration: InputDecoration(
                      labelText: "Nombre",
                      labelStyle: textTheme.bodyMedium,
                    ),
                    style: textTheme.bodyLarge,
                    validator: _required,
                  ),
                ),
                const SizedBox(height: 10),
                _buildCompactField(
                  child: TextFormField(
                    controller: _descCtrl,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: "Descripción",
                      labelStyle: textTheme.bodyMedium,
                    ),
                    style: textTheme.bodyLarge,
                    validator: _required,
                  ),
                ),
                const SizedBox(height: 10),

                Text("Tipo", style: textTheme.titleMedium),
                Wrap(
                  spacing: 8,
                  children: _types.map((t) {
                    final label = t == 'REPETITION' ? 'Repeticiones' : 'Duración';
                    return ChoiceChip(
                      label: Text(label, style: textTheme.bodyMedium),
                      selected: _type == t,
                      onSelected: (_) => setState(() => _type = t),
                    );
                  }).toList(),
                ),

                if (_type == 'TIME') ...[
                  const SizedBox(height: 12),
                  _buildCompactField(
                    child: TextFormField(
                      controller: _timeCtrl,
                      decoration: InputDecoration(
                        labelText: "Tiempo",
                        labelStyle: textTheme.bodyMedium,
                      ),
                      style: textTheme.bodyLarge,
                      keyboardType: TextInputType.number,
                      validator: _limitTime,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text("Unidad", style: textTheme.titleMedium),
                  Wrap(
                    spacing: 8,
                    children: _unitOptions.map((u) {
                      return ChoiceChip(
                        label: Text(u['label']!, style: textTheme.bodyMedium),
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
                      decoration: InputDecoration(
                        labelText: "Cantidad de veces a realizar",
                        labelStyle: textTheme.bodyMedium,
                      ),
                      style: textTheme.bodyLarge,
                      keyboardType: TextInputType.number,
                      validator: _limitRep,
                    ),
                  ),
                ],

                const SizedBox(height: 12),
                Text("Categoría", style: textTheme.titleMedium),
                Wrap(
                  spacing: 8,
                  children: _categories.map((cat) {
                    return ChoiceChip(
                      label: Text(cat, style: textTheme.bodyMedium),
                      selected: _category == cat,
                      onSelected: (_) => setState(() => _category = cat),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 12),
                _buildCompactField(
                  child: TextFormField(
                    controller: _urlCtrl,
                    decoration: InputDecoration(
                      labelText: "URL del video",
                      labelStyle: textTheme.bodyMedium,
                    ),
                    style: textTheme.bodyLarge,
                  ),
                ),

                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton.icon(
                    onPressed: _openVideoSelectorModal,
                    icon: const Icon(Icons.video_library),
                    label: Text("Importar video", style: textTheme.labelLarge),
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


  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Campo obligatorio';
    }
    return null;
  }

  String? _limitRep(String? value) {
    if (value == null) return "Campo obligatorio";
    final intValue = int.tryParse(value);
    if (intValue == null) return "Debe ser un número";
    return (intValue > 0 && intValue < 10) ? null : "El valor debe estar entre 1 y 9";
  }

  String? _limitTime(String? value) {
    if (value == null) return "Campo obligatorio";
    final intValue = int.tryParse(value);
    if (intValue == null) return "Debe ser un número";
    return (intValue > 0 && intValue < 60) ? null : "El valor debe estar entre 1 y 59";
  }
}






