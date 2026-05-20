import 'package:flutter/material.dart';

class ShowExceptionDialog {
  static Future<void> show(BuildContext context, int errorCode, String message) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Error $errorCode'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
