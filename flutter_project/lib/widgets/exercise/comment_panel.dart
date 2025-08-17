import 'package:flutter/material.dart';

class CommentsPanel extends StatefulWidget {
  final List<dynamic> initialComments;
  final VoidCallback onClose;
  final Future<Map<String, dynamic>?> Function(String commentText) onSendComment;

  const CommentsPanel({
    required this.initialComments,
    required this.onClose,
    required this.onSendComment,
    super.key,
  });

  @override
  State<CommentsPanel> createState() => _CommentsPanelState();
}

class _CommentsPanelState extends State<CommentsPanel> {
  final TextEditingController _controller = TextEditingController();
  late List<dynamic> comments;

  @override
  void initState() {
    super.initState();
    comments = List.from(widget.initialComments);
  }

  void _submitComment() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final updatedTraining = await widget.onSendComment(text);

    if (updatedTraining != null) {
      if (!mounted) return;
      setState(() {
        comments = List.from(updatedTraining['comments'] ?? []);
        _controller.clear();
      });
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al enviar comentario')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      height: MediaQuery.of(context).size.height * 0.45,
      child: Material(
        elevation: 8,
        color: theme.colorScheme.surface, // fondo adaptativo
        child: Column(
          children: [
            // Encabezado
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: theme.colorScheme.primary, // barra adaptativa
              child: Row(
                children: [
                  Text(
                    'Comentarios',
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary, // texto legible
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.close, color: theme.colorScheme.onPrimary),
                    onPressed: widget.onClose,
                  ),
                ],
              ),
            ),
            // Lista de comentarios
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: comments.map<Widget>((c) {
                  final userName = c['user'] != null ? c['user']['name'] ?? 'Anónimo' : 'Anónimo';
                  final commentText = c['comment'] ?? '';

                  return Card(
                    color: theme.cardColor, // adaptativo
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                    child: ListTile(
                      leading: Icon(Icons.comment, color: theme.colorScheme.secondary),
                      title: Text(userName, style: TextStyle(color: theme.textTheme.bodyMedium!.color)),
                      subtitle: Text(commentText, style: TextStyle(color: theme.textTheme.bodySmall!.color)),
                    ),
                  );
                }).toList(),
              ),
            ),
            // Campo de texto para nuevo comentario
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Agregar comentario...',
                  labelStyle: TextStyle(color: theme.textTheme.bodyMedium!.color),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.dividerColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.colorScheme.primary),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send, color: theme.colorScheme.primary),
                    onPressed: _submitComment,
                  ),
                ),
                style: TextStyle(color: theme.textTheme.bodyMedium!.color),
                onSubmitted: (_) => _submitComment(),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

