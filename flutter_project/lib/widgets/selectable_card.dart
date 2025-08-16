import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'adaptative_colors.dart';

class SelectableCard extends StatelessWidget {
  final bool selected;
  final Widget child;
  final VoidCallback? onTap;

  const SelectableCard({
    required this.selected,
    required this.child,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AdaptiveColors(selected: selected, context: context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: colors.card,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: isDark ? Colors.grey.shade600 : Colors.grey.shade300,
            width: 1.2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: DefaultTextStyle(
            style: TextStyle(color: colors.text),
            child: child,
          ),
        ),
      ),
    );
  }
}

