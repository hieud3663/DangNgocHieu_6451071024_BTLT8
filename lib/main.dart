import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'apps/app.dart';

void main() {
  runApp(const MainApp());
}

@Preview(size: Size(300, 500))
Widget previewMainApp() => const MainApp();