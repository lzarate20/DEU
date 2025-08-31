import 'package:flutter/material.dart';

class CommentToggleBar extends StatelessWidget {
  final bool showComments;
  final VoidCallback onTap;

  const CommentToggleBar({
    required this.showComments,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = theme.brightness == Brightness.dark
        ? theme.colorScheme.primary
        : theme.colorScheme.primary;
    final contentColor = theme.colorScheme.onSurface;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border(
            bottom: BorderSide(
              color: theme.dividerColor,
              width: 1.5,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 2),
              blurRadius: 3,
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.comment, color: contentColor),
            const SizedBox(width: 8),
            Text(
              'Comentarios',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: contentColor,
              ),
            ),
            const Spacer(),
            Icon(
              showComments ? Icons.expand_less : Icons.expand_more,
              color: contentColor,
            ),
          ],
        ),
      ),
    );
  }
}


