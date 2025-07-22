import 'package:flutter/material.dart';
import 'package:flutter_project/widgets/base_layout.dart';
import 'package:flutter_project/pages/training_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  void _handlePopupSelection(String value) {
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: TrainingPage()));
  }
}
