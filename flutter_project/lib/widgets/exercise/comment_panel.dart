import 'package:flutter/material.dart';

class CommentsPanel extends StatelessWidget {
  final List<dynamic> comments;
  final VoidCallback onClose;

  const CommentsPanel({
    required this.comments,
    required this.onClose,
    super.key,
  });

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
                    onPressed: onClose,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: comments.map<Widget>((c) {
                  return ListTile(
                    leading: const Icon(Icons.comment),
                    title: Text(c['idUser']['name'] ?? ''),
                    subtitle: Text(c['comment'] ?? ''),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Agregar comentario...',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.send),
                ),
                onSubmitted: (text) {
                  // lógica de envío
                },
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
