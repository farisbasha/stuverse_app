import 'package:flutter/material.dart';

class CommonUtils {
  static void showSnackbar(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      elevation: 0,
      content: Text(
        message,
        style: TextStyle(
            color: isError
                ? Theme.of(context).colorScheme.onError
                : Theme.of(context).colorScheme.onPrimaryContainer),
      ),
      duration: duration,
      backgroundColor: isError
          ? Theme.of(context).colorScheme.error
          : Theme.of(context).colorScheme.primaryContainer,
    ));
  }

  static void showDialogbox(
    BuildContext context, {
    required String title,
    bool isError = false,
    String? subtitle,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: isError
              ? Icon(
                  Icons.error,
                  color: Theme.of(context).colorScheme.error,
                  size: 35,
                )
              : null,
          title: Text(title,
              style: TextStyle(
                  color: isError
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).colorScheme.onBackground)),
          content: subtitle != null
              ? Text(subtitle,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground))
              : null,
          backgroundColor: Theme.of(context).colorScheme.background,
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
