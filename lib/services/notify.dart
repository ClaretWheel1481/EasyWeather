import 'package:flutter/material.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void showNotification(String title, String content) {
  final snackBar = SnackBar(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(content),
        ],
      ),
      duration: const Duration(milliseconds: 3500),
      behavior: SnackBarBehavior.floating);

  scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
}
