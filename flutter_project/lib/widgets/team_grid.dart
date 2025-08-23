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


    for (var team in teams) {
      final name = team['name'] ?? 'Equipo';
      final users = team['users'] as List<dynamic>? ?? [];

      const double maxTitleWidth = 200;

      final textPainterTitle = TextPainter(
        text: TextSpan(text: name, style: textStyleTitle),
        textDirection: TextDirection.ltr,
        maxLines: 2,
      )..layout(maxWidth: maxTitleWidth);

      final textPainterSubtitle = TextPainter(
        text: TextSpan(text: '${users.length} miembros', style: textStyleSubtitle),
        textDirection: TextDirection.ltr,
      )..layout();

      final cardWidth = textPainterTitle.width > textPainterSubtitle.width
          ? textPainterTitle.width
          : textPainterSubtitle.width;

      final cardHeight = textPainterTitle.height + textPainterSubtitle.height + 24; // padding interno

      if (cardWidth > maxWidth) maxWidth = cardWidth;
      if (cardHeight > maxHeight) maxHeight = cardHeight;
    }

    // Agregamos un poco de padding
    maxWidth += 16;
    maxHeight += 16;

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
              children: [
                Flexible(
                  child: Text(
                    name,
                    style: textStyleTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 8),
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

