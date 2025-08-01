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
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: double.infinity,
        color: Colors.grey.shade300,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            const Icon(Icons.comment),
            const SizedBox(width: 8),
            const Text('Comentarios', style: TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            Icon(showComments ? Icons.expand_less : Icons.expand_more),
          ],
        ),
      ),
    );
  }
}
