import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../services/training_service.dart';


class TrainingListPage extends StatefulWidget {
  const TrainingListPage({super.key});

  @override
  State<TrainingListPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingListPage> {
  final TrainingService _service = TrainingService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>?>(
      future: _service.fetchTrainings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final trainings = snapshot.data ?? [];

        if (trainings.isEmpty) {
          return const Center(child: Text('No hay entrenamientos disponibles.'));
        }

        return ListView.builder(
          itemCount: trainings.length,
          itemBuilder: (context, index) {
            final training = trainings[index];

            return ListTile(
              title: Text(training['name'] ?? 'Sin nombre'),
              subtitle: Text(training['description'] ?? ''),
              trailing: Text(training['date'] ?? ''),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/training',
                  arguments: training,
                );
              },
            );
          },
        );
      },
    );
  }
}
