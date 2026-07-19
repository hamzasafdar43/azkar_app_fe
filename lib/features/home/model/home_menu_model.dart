import 'package:flutter/material.dart';

class HomeMenuModel {

  final String title;
  final String subtitle;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;
  final Color subtitleColor;
  final Widget screen;

  const HomeMenuModel({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    required this.subtitleColor,
    required this.textColor,

    required this.screen,
  });
}