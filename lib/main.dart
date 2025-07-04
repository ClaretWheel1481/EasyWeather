import 'package:flutter/material.dart';
import 'core/startup.dart';
import 'app.dart';

Future<void> main() async {
  await initAppSettings();
  runApp(const ZephyrApp());
}
