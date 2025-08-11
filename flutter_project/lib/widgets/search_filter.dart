import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SearchFilters extends StatelessWidget {
  final TextEditingController controller;
  final DateTime? startDate;
  final DateTime? endDate;
  final VoidCallback? onClearDates;
  final VoidCallback? onPickStartDate;
  final VoidCallback? onPickEndDate;
  final ValueChanged<String> onSearch;
  final bool showDateFilters;

  const SearchFilters({
    super.key,
    required this.controller,
    required this.onSearch,
    this.showDateFilters = true,
    this.startDate,
    this.endDate,
    this.onPickStartDate,
    this.onPickEndDate,
    this.onClearDates,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd');

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Buscar por nombre, tipo o entrenador',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: onSearch,
          ),
        ),
        if (showDateFilters) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onPickStartDate,
                    icon: const Icon(Icons.date_range),
                    label: Text(startDate == null
                        ? 'Desde'
                        : 'Desde: ${dateFormat.format(startDate!)}'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onPickEndDate,
                    icon: const Icon(Icons.date_range),
                    label: Text(endDate == null
                        ? 'Hasta'
                        : 'Hasta: ${dateFormat.format(endDate!)}'),
                  ),
                ),
                IconButton(
                  onPressed: onClearDates,
                  tooltip: 'Limpiar fechas',
                  icon: const Icon(Icons.clear, color: Colors.red),
                )
              ],
            ),
          ),
        ],
      ],
    );
  }
}

