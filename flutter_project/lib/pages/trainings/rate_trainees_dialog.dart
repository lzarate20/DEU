import 'package:flutter/material.dart';
import '../../models/evaluation.dart';
import '../../services/evaluation_service.dart';
import '../../services/user_service.dart';

class RateStudentsDialog extends StatefulWidget {
  final int trainingId;
  final List<int> trainees;

  const RateStudentsDialog({
    required this.trainingId,
    required this.trainees,
    super.key,
  });

  @override
  State<RateStudentsDialog> createState() => _RateStudentsDialogState();
}

class _RateStudentsDialogState extends State<RateStudentsDialog> {
  late Map<int, int> _scores;
  Map<int, int> _existingScores = {};
  List<Map<String, dynamic>> _users = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _scores = {for (var id in widget.trainees) id: 0};
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final userService = UserService();
    final allUsers = await userService.fetchUsers();
    final filteredUsers = allUsers
        .where((user) => widget.trainees.contains(user['id']))
        .toList();

    final evaluationService = EvaluationService();

    final Map<int, int> existingScores = {};
    final Map<int, int> scores = {for (var user in filteredUsers) user['id']: 0};

    for (var user in filteredUsers) {
      final evaluation = await evaluationService.getUserEvaluation(
        userId: user['id'],
        trainingId: widget.trainingId,
      );
      existingScores[user['id']] = evaluation?.score.toInt() ?? 0;
    }

    setState(() {
      _users = filteredUsers;
      _existingScores = existingScores;
      _scores = scores;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Puntuar alumnos',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: 500,
        height: MediaQuery.of(context).size.height * 0.5,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: _users.length,
          itemBuilder: (context, index) {
            final student = _users[index];
            final score = _scores[student['id']] ?? 0;
            final alreadyRated =
                (_existingScores[student['id']] ?? 0) > 0;

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 12, horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            student['name'],
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            student['position'] ?? '-',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600]),
                          ),
                          if (alreadyRated)
                            Text(
                              'Ya puntuado: ${_existingScores[student['id']]} ⭐',
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 12),
                            ),
                        ],
                      ),
                    ),
                    Row(
                      children: List.generate(5, (i) {
                        final starIndex = i + 1;
                        return IconButton(
                          icon: Icon(
                            starIndex <= score
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                          ),
                          onPressed: alreadyRated
                              ? null
                              : () {
                            setState(() {
                              _scores[student['id']] =
                              (score == starIndex) ? 0 : starIndex;
                            });
                          },
                          iconSize: 30,
                          splashRadius: 20,
                        );
                      }),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: _loading
              ? null
              : () async {
            Navigator.pop(context);

            final service = EvaluationService();
            for (var entry in _scores.entries) {
              if ((_existingScores[entry.key] ?? 0) == 0 && entry.value > 0) {
                final evaluation = EvaluationDTO(
                  userId: entry.key,
                  trainingId: widget.trainingId,
                  score: entry.value.toDouble(),
                );
                await service.postEvaluation(evaluation);
              }
            }

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Puntuaciones guardadas')),
            );
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}




