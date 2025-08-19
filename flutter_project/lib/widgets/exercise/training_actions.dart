// TrainingActions.dart
import 'package:flutter/material.dart';
import 'package:flutter_project/services/training_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../pages/trainings/rate_trainees_dialog.dart';

class TrainingActions extends StatefulWidget {
  final Map<String, dynamic> training;
  final VoidCallback? onCopied;
  final VoidCallback? onDeleted;
  final VoidCallback? onAssign;

  const TrainingActions({
    required this.training,
    this.onCopied,
    this.onDeleted,
    this.onAssign,
    super.key,
  });

  @override
  State<TrainingActions> createState() => _TrainingActionsState();
}

class _TrainingActionsState extends State<TrainingActions> {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  bool _isOwner = false;

  @override
  void initState() {
    super.initState();
    _checkOwnership();
  }

  Future<void> _checkOwnership() async {
    final userId = await _secureStorage.read(key: 'user_id');
    setState(() {
      _isOwner = userId == widget.training['trainer']['id'].toString();
    });
  }

  void _copyTraining() {
    TrainingService().copyTraining(widget.training);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Entrenamiento copiado')),
    );
    widget.onCopied?.call();
  }

  void _assignTraining() {
    widget.onAssign?.call();
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar entrenamiento'),
        content: const Text('¿Estás seguro de que querés eliminar este entrenamiento?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await _deleteTraining();
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteTraining() async {
    await TrainingService().removeTraining(widget.training["id"].toString());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Entrenamiento eliminado')),
    );
    widget.onDeleted?.call();
  }

  void _rateStudents() async {
    await showDialog(
      context: context,
      builder: (_) => RateStudentsDialog(
        trainingId: int.tryParse(widget.training['id'].toString()) ?? 0,
        trainees:  List<int>.from(widget.training['trainees']),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (_isOwner) ...[
          IconButton(
            icon: const Icon(Icons.list_alt),
            onPressed: _assignTraining,
            tooltip: 'Asignar entrenamiento',
          ),
        ],
        IconButton(
          icon: const Icon(Icons.copy),
          onPressed: _copyTraining,
          tooltip: 'Copiar entrenamiento',
        ),
        IconButton(
          icon: const Icon(Icons.star),
          onPressed: _rateStudents,
          tooltip: 'Puntuar alumnos',
        ),
        if (_isOwner) ...[
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _confirmDelete,
            tooltip: 'Eliminar entrenamiento',
          ),
        ],
      ],
    );
  }
}

