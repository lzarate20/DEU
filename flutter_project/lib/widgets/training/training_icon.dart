import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

IconData getTrainingIcon(String type) {
  switch (type.toUpperCase()) {
    case 'STRENGTH':
      return Icons.fitness_center;
    case 'SPEED':
      return Icons.directions_run;
    case 'DRIBBLING':
      return Icons.sports_football;
    default:
      return Icons.fitness_center;
  }
}

Color getTrainingIconColor(String type) {
  switch (type.toUpperCase()) {
    case 'STRENGTH':
      return Colors.redAccent;
    case 'SPEED':
      return Colors.blueAccent;
    case 'DRIBBLING':
      return Colors.green;
    default:
      return Colors.grey;
  }
}
