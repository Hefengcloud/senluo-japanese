import 'package:flutter/material.dart';

class NavigationItem {
  final Icon icon;
  final Icon selectedIcon;
  final String label;
  final Widget page;

  NavigationItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.page,
  });
}
