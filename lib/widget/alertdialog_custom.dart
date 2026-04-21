import 'package:flutter/material.dart';

class AlertDialogCustom extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;
  final IconData icon;
  final Color iconColor;

  const AlertDialogCustom({
    super.key,
    this.title = 'Profile Update',
    this.content = 'Are you sure you want to save changes?',
    this.confirmText = 'Yes, Save',
    this.cancelText = 'Cancel',
    this.icon = Icons.check_circle,
    this.iconColor = Colors.green,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      icon: Icon(icon, color: iconColor, size: 60),
      title: Text(title),
      content: Text(
        content,
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(cancelText, style: TextStyle(color: Colors.red)),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(confirmText, style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
