import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateDialog extends StatelessWidget {
  final String title;
  final String message;
  final Function() onUpdate;
  final Function() onLater;

  const UpdateDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.onUpdate,
    required this.onLater,
  }) : super(key: key);

  static void show(BuildContext context, {
    required String title,
    required String message,
    required Function() onUpdate,
    required Function() onLater,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => UpdateDialog(
        title: title,
        message: message,
        onUpdate: onUpdate,
        onLater: onLater,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      // Set RTL for Arabic
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        actions: [
          TextButton(
            onPressed: onLater,
            child: const Text(
              'لاحقاً',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: onUpdate,
            child: const Text('تحديث الآن'),
          ),
        ],
      ),
    );
  }
}

