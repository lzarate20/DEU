import 'package:flutter/material.dart';

class TrainingForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl;
  final TextEditingController descCtrl;
  final DateTime? selectedDate;
  final VoidCallback onPickDate;
  final String trainingType;
  final ValueChanged<String> onTrainingTypeChanged;
  final List<String> trainingTypes;
  final Map<String, String> trainingTypeLabels;

  const TrainingForm({
    super.key,
    required this.formKey,
    required this.nameCtrl,
    required this.descCtrl,
    required this.selectedDate,
    required this.onPickDate,
    required this.trainingType,
    required this.onTrainingTypeChanged,
    required this.trainingTypes,
    required this.trainingTypeLabels

  });

  Widget _buildCompactField({required Widget child}) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCompactField(
            child: TextFormField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Nombre del entrenamiento"),
              validator: (v) => v!.isEmpty ? "Campo obligatorio" : null,
            ),
          ),
          _buildCompactField(
            child: TextFormField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: "Descripción"),
              validator: (v) => v!.isEmpty ? "Campo obligatorio" : null,
            ),
          ),
          _buildCompactField(
            child: TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Fecha del entrenamiento",
                suffixIcon: const Icon(Icons.calendar_today),
                border: const UnderlineInputBorder(),
                hintText: "Seleccioná una fecha",
              ),
              controller: TextEditingController(
                text: selectedDate == null
                    ? ''
                    : selectedDate!.toIso8601String().split("T").first,
              ),
              onTap: onPickDate,
              validator: (_) =>
              selectedDate == null ? "Seleccioná una fecha" : null,
            ),
          ),
          _buildCompactField(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Tipo de entrenamiento:", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: trainingTypes.map((type) {
                    final label = trainingTypeLabels[type] ?? type;
                    return ChoiceChip(
                      label: Text(label),
                      selected: trainingType == type,
                      onSelected: (_) => onTrainingTypeChanged(type),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
