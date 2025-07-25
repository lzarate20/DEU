import 'package:flutter/material.dart';
import 'package:flutter_project/pages/training_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(16.0), child: TrainingPage());
  }
}
