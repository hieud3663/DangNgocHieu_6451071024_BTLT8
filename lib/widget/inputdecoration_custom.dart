import 'package:flutter/material.dart';

class InputDecorationCustom {
  final String labelText;
  final String hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Color borderColor;
  final Widget? suffix;

  const InputDecorationCustom({
    this.labelText = '',
    this.hintText = '',
    this.prefixIcon,
    this.suffixIcon,
    this.borderColor = Colors.green,
    this.suffix,
  });

  InputDecoration build() => InputDecoration(
    labelText: labelText,
    hintText: hintText,
    prefixIcon: prefixIcon != null
        ? Icon(prefixIcon, color: borderColor)
        : null,
    suffixIcon: suffixIcon != null
        ? Icon(suffixIcon, color: borderColor)
        : null,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: borderColor, width: 2),
      borderRadius: BorderRadius.circular(8.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: borderColor, width: 2),
      borderRadius: BorderRadius.circular(8.0),
    ),
    suffix: suffix,
  );
}
