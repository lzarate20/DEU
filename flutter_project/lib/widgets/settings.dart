import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_project/widgets/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsModalContent extends StatelessWidget {
  const SettingsModalContent({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Tamaño de fuente: ${_labelForFactor(themeProvider.fontSizeFactor)}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              showValueIndicator: ShowValueIndicator.always,
              valueIndicatorTextStyle: const TextStyle(color: Colors.white),
              activeTrackColor: Theme.of(context).colorScheme.primary,
              inactiveTrackColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              thumbColor: Theme.of(context).colorScheme.primary,
              overlayColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
            child: Slider(
              min: 0.7,
              max: 1.7,
              divisions: 2,
              label: _labelForFactor(themeProvider.fontSizeFactor),
              value: themeProvider.fontSizeFactor,
              onChanged: (value) {
                final rounded = double.parse(value.toStringAsFixed(1));
                debugPrint('Nuevo fontSizeFactor: $rounded');
                themeProvider.setFontSizeFactor(rounded);
              },
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  String _labelForFactor(double factor) {
    switch (factor.toStringAsFixed(1)) {
      case '0.7':
        return 'Pequeño';
      case '1.0':
        return 'Mediano';
      case '1.7':
        return 'Grande';
      default:
        return '';
    }
  }
}