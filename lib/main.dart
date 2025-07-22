import 'package:flutter/material.dart';
import 'package:zephyr/app.dart';
import 'core/startup.dart';

Future<void> main() async {
  await initAppSettings();

  runApp(const ZephyrApp());
}
