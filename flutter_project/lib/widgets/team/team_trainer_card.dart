import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TrainerCard extends StatelessWidget {
  final dynamic trainer;

  const TrainerCard({super.key, required this.trainer});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Entrenador", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            const Divider(thickness: 2, height: 20),
            if (trainer != null)
              ListTile(
                leading: const Icon(Icons.sports),
                title: Text(trainer['name'] ?? 'Desconocido'),
                subtitle: Text(trainer['email'] ?? ''),
              )
            else
              const Text("No se encontró entrenador asignado."),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }
}