import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/services/auth_service.dart';
import 'package:flutter_project/services/evaluation_service.dart';
import 'package:flutter_project/services/training_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../models/evaluation.dart';
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
  bool _isTrainer = false;
  bool _hasRated = false;

  @override
  void initState() {
    super.initState();
    _checkOwnership();
    _checkIsTrainer();
    _checkIfRated();
  }

  Future<void> _checkOwnership() async {
    final userIdStr = await _secureStorage.read(key: 'user_id');
    final userId = int.tryParse(userIdStr ?? '');
    final trainerId = widget.training['trainer']?['id'];
    setState(() {
      _isOwner = trainerId != null && userId != null && trainerId == userId;
    });
  }

  Future<void> _checkIsTrainer() async {
    final isTrainer = await AuthService.isTrainer();
    setState(() {
      _isTrainer = isTrainer;
    });
  }

  Future<void> _checkIfRated() async {
    final userIdStr = await AuthService.getLoggedUserId();
    final userId = int.tryParse(userIdStr ?? '');
    final trainingId = int.tryParse(widget.training['id'].toString()) ?? 0;

    if (userId == null) return;

    final existingEvaluation = await EvaluationService().getUserEvaluation(
      userId: userId,
      trainingId: trainingId,
    );

    setState(() {
      _hasRated = existingEvaluation != null && existingEvaluation.score > 0;
      widget.training['userRated'] =
          _hasRated;
    });
  }

  void _copyTraining() {
    TrainingService().copyTraining(widget.training);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Entrenamiento copiado')));
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
        content: const Text(
          '¿Estás seguro de que querés eliminar este entrenamiento?',
        ),
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
    final trainingId = widget.training["id"];
    if (trainingId == null) return;
    await TrainingService().removeTraining(trainingId.toString());
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Entrenamiento eliminado')));
    widget.onDeleted?.call();
  }

  void _rateStudents() async {
    final traineesList = widget.training['trainees'] as List?;
    if (traineesList == null) return;
    final trainees = traineesList
        .map((e) => int.tryParse(e.toString()) ?? 0)
        .toList();

    await showDialog(
      context: context,
      builder: (_) => RateStudentsDialog(
        trainingId: int.tryParse(widget.training['id'].toString()) ?? 0,
        trainees: trainees,
      ),
    );
  }

  bool get _hasTraining {
    final trainees = widget.training['trainees'] as List<dynamic>? ?? [];
    debugPrint(trainees.contains(AuthService.getLoggedUserId()).toString());
    return trainees.contains(AuthService.getLoggedUserId());
  }

  void _rateTraining() async {
    final userIdStr = await AuthService.getLoggedUserId();
    final userId = int.tryParse(userIdStr ?? '');
    final trainingId = int.tryParse(widget.training['id'].toString()) ?? 0;

    if (userId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Error: usuario inválido")));
      return;
    }

    final existingEvaluation = await EvaluationService().getUserEvaluation(
      userId: userId,
      trainingId: trainingId,
    );

    final bool hasRated =
        existingEvaluation != null && existingEvaluation.score > 0;

    if (hasRated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ya calificaste este entrenamiento.")),
      );
      setState(() {
        _hasRated = true;
        widget.training['userRated'] = true;
      });
      return;
    }

    int selectedRating = 0;

    final rating = await showDialog<int>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Puntuar entrenamiento"),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final starIndex = index + 1;
                return IconButton(
                  icon: Icon(
                    starIndex <= selectedRating
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.amber,
                    size: 40,
                  ),
                  onPressed: () => setState(() => selectedRating = starIndex),
                );
              }),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancelar"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, selectedRating),
                child: const Text("Guardar"),
              ),
            ],
          );
        },
      ),
    );

    if (rating != null && rating > 0) {
      final evaluation = EvaluationDTO(
        userId: userId,
        trainingId: trainingId,
        score: rating.toDouble(),
      );

      final result = await EvaluationService().postEvaluation(evaluation);

      if (result != null) {
        setState(() {
          _hasRated = true;
          widget.training['userRated'] = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Calificación guardada: ${result.score} estrellas"),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al guardar la calificación")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isTrainer) {
      if (!_hasTraining) {
        return const SizedBox.shrink();
      }

      if (_hasRated) {
        return const SizedBox.shrink();
      }
      return Row(
        children: [
          IconButton(
            icon: const Icon(Icons.star),
            onPressed: _rateTraining,
            tooltip: 'Puntuar entrenamiento',
          ),
        ],
      );
    }

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
        if (_isOwner) ...[
          IconButton(
            icon: const Icon(Icons.star),
            onPressed: _rateStudents,
            tooltip: 'Puntuar alumnos',
          ),
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
