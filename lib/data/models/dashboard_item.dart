import 'package:flutter/material.dart';

class DashboardItem {
  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;

  const DashboardItem({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
  });
}
