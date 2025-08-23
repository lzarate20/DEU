import 'package:flutter/material.dart';
import 'package:flutter_project/widgets/selectable_card.dart';
import 'package:go_router/go_router.dart';

class TeamsGrid extends StatelessWidget {
  final List<Map<String, dynamic>> teams;

  const TeamsGrid({super.key, required this.teams});

  @override
  Widget build(BuildContext context) {
    double maxWidth = 0;
    double maxHeight = 0;

    final textStyleTitle = Theme.of(context).textTheme.bodyLarge?.copyWith(
      fontWeight: FontWeight.bold,
    );
    final textStyleSubtitle = Theme.of(context).textTheme.bodyMedium;

    const double maxTitleWidth = 220; // ancho máximo que puede ocupar un título

    // 🔹 1) Medimos todos los títulos y subtítulos
    for (var team in teams) {
      final name = team['name'] ?? 'Equipo';
      final users = team['users'] as List<dynamic>? ?? [];

      // Medimos título (máximo 2 líneas, ancho limitado)
      final textPainterTitle = TextPainter(
        text: TextSpan(text: name, style: textStyleTitle),
        textDirection: TextDirection.ltr,
        maxLines: 2,
      )..layout(maxWidth: maxTitleWidth);

      // Medimos subtítulo
      final textPainterSubtitle = TextPainter(
        text: TextSpan(text: '${users.length} miembros', style: textStyleSubtitle),
        textDirection: TextDirection.ltr,
      )..layout();

      // Tomamos el mayor ancho entre título y subtítulo
      final cardWidth = textPainterTitle.width > textPainterSubtitle.width
          ? textPainterTitle.width
          : textPainterSubtitle.width;

      // Alto = título (2 líneas posibles) + subtítulo + padding
      final cardHeight = textPainterTitle.height + textPainterSubtitle.height + 32;

      if (cardWidth > maxWidth) maxWidth = cardWidth;
      if (cardHeight > maxHeight) maxHeight = cardHeight;
    }

    // Agregamos márgenes internos
    maxWidth += 24;
    maxHeight += 24;

    // 🔹 2) Renderizamos todas las tarjetas con el mismo tamaño calculado
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: teams.map((team) {
        final users = team['users'] as List<dynamic>? ?? [];
        final name = team['name'] ?? 'Equipo';

        return SizedBox(
          width: maxWidth,
          height: maxHeight,
          child: SelectableCard(
            selected: false,
            onTap: () => context.go('/team/${team['id']}', extra: team),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: textStyleTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${users.length} miembros',
                  style: textStyleSubtitle,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}


