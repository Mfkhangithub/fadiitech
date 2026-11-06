import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SkillModel {
  final String name;
  final FaIconData icon;
  final double level;
  final String? fullName;

  SkillModel({
    required this.name,
    required this.icon,
    required this.level,
    this.fullName,
  });
}
