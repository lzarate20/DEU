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
      if (!mounted) return; // <-- Evita setState si el widget ya no está
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
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      height: MediaQuery.of(context).size.height * 0.45,
      child: Material(
        elevation: 8,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.blueGrey.shade700,
              child: Row(
                children: [
                  const Text('Comentarios', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: widget.onClose,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: comments.map<Widget>((c) {
                  final userName = c['user'] != null ? c['user']['name'] ?? 'Anónimo' : 'Anónimo';
                  final commentText = c['comment'] ?? '';

                  return ListTile(
                    leading: const Icon(Icons.comment),
                    title: Text(userName),
                    subtitle: Text(commentText),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Agregar comentario...',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _submitComment,
                  ),
                ),
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
