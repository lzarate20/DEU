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
        mainAxisSize: MainAxisSize.min, // ocupa sólo el espacio necesario
        children: [
          Text('Tamaño de fuente: ${themeProvider.fontSizeFactor.toStringAsFixed(2)}'),
          Slider(
            min: 0.8,
            max: 2.0,
            divisions: 12,
            value: themeProvider.fontSizeFactor,
              onChanged: (value) {
                debugPrint('Nuevo fontSizeFactor: $value');
                themeProvider.setFontSizeFactor(value);
              },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(), // cerrar modal
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}