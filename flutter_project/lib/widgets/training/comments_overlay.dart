import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../exercise/comment_panel.dart';

class CommentsOverlay extends StatelessWidget {
  final List<dynamic> comments;
  final VoidCallback onClose;
  final Future<Map<String, dynamic>?> Function(String) onSendComment;

  const CommentsOverlay({
    super.key,
    required this.comments,
    required this.onClose,
    required this.onSendComment,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ModalBarrier(
          color: Colors.black54,
          dismissible: true,
          onDismiss: onClose,
        ),
        CommentsPanel(
          initialComments: comments,
          onClose: onClose,
          onSendComment: onSendComment,
        ),
      ],
    );
  }
}