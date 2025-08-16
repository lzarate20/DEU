import 'package:flutter/material.dart';

class AdaptiveColors {
  final bool selected;
  final BuildContext context;

  AdaptiveColors({required this.selected, required this.context});

  Color get card {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (!selected) return theme.cardColor;
    return isDark ? Colors.blueGrey.shade700 : Colors.blue.shade50;
  }

  Color get text {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (!selected) return theme.textTheme.bodyMedium!.color!;
    return isDark ? Colors.white : Colors.black;
  }
}