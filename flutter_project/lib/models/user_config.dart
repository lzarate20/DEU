import 'package:flutter/material.dart';

enum ThemeType { light, dark }
enum LetterSize { small, medium, large }

class UserConfig {
  final int id;
  final int idUser;
  final ThemeType theme;
  final LetterSize letterSize;

  UserConfig({
    required this.id,
    required this.idUser,
    required this.theme,
    required this.letterSize,
  });

  factory UserConfig.fromJson(Map<String, dynamic> json) {
    debugPrint('Response en mapper: ${json['theme']}, ${json['letterSize']}');
    return UserConfig(
      id: json['id'],
      idUser: json['idUser'],
      theme: themeTypeFromString(json['theme']),
      letterSize: letterSizeFromString(json['letterSize']),
    );
  }
}

ThemeType themeTypeFromString(String? value) {
  switch (value?.toUpperCase()) {
    case 'NIGHT':
      return ThemeType.dark;
    case 'DAY':
      return ThemeType.light;
    default:
      return ThemeType.light;
  }
}

LetterSize letterSizeFromString(String? value) {
  final lowerValue = value?.toLowerCase();
  return LetterSize.values.firstWhere(
        (e) => e.name.toLowerCase() == lowerValue,
    orElse: () => LetterSize.medium,
  );
}