import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stuverse_app/utils/secrets.dart';
import 'package:url_launcher/url_launcher.dart';

class CommonUtils {
  static void showSnackbar(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
    bool isError = false,
    SnackBarAction? action,
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
      action: action,
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
      builder: (BuildContext ctx) {
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
                Navigator.of(ctx).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static void navigatePush(BuildContext context, Widget widget) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => widget));
  }

  static void navigatePushReplacement(BuildContext context, Widget widget) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => widget));
  }

  static void navigatePop(BuildContext context) {
    Navigator.of(context).pop();
  }

  static void navigatePushReplacementAll(BuildContext context, Widget widget) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (ctx) => widget),
        (Route<dynamic> route) => false);
  }

  static void setIsFirstTime() async {
    bool isViewed = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboard', isViewed);
  }

  static Future<bool> getIsFirstTime() async {
    print('getting isFirstime Status');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isViewed = prefs.getBool('isFirst') ?? false;
    return isViewed;
  }

  static String formatRealisticDate(String inputDate) {
    final inputFormat = DateFormat('yyyy-MM-ddTHH:mm:ssZ');
    final outputFormat = DateFormat.yMMMMd();

    final date = inputFormat.parse(inputDate);
    return outputFormat.format(date);
  }

  static String getYear(String inputDate) {
    final inputFormat = DateFormat('yyyy-MM-ddTHH:mm:ssZ');
    final outputFormat = DateFormat('yyyy');

    final date = inputFormat.parse(inputDate);
    return outputFormat.format(date);
  }

  static String formatDateWithTime(String inputDate) {
    final inputFormat = DateFormat('yyyy-MM-ddTHH:mm:ssZ');
    final outputFormat = DateFormat.yMMMMd().add_jm();

    final date = inputFormat.parse(inputDate);
    return outputFormat.format(date);
  }

  static void launchPhone(BuildContext context, String phone) async {
    Uri url = Uri(
      scheme: 'tel',
      path: phone,
    );
    if (!await launchUrl(url)) {
      showSnackbar(context, message: 'Could not launch Phone', isError: true);
    }
  }

  static bool isKeyboardShowing() {
    if (WidgetsBinding.instance != null) {
      return WidgetsBinding.instance.window.viewInsets.bottom > 0;
    } else {
      return false;
    }
  }

  static closeKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  static String formatChatDate(String dateString) {
    final DateTime now = DateTime.now();
    DateTime dateTime = DateTime.parse(dateString).toLocal();

    final diff = now.difference(dateTime);

    if (diff.inDays >= 1) {
      final formatter = DateFormat('h:mm');
      return '${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago';
    } else {
      final formatter = DateFormat('h:mm a');
      return formatter.format(dateTime);
    }
  }
}
