import 'package:shared_preferences/shared_preferences.dart';
import 'notifiers.dart';
import 'package:flutter/material.dart';

Future<void> initAppSettings() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  themeModeNotifier.value = ThemeMode.values[prefs.getInt('theme_mode') ?? 2];
  tempUnitNotifier.value = prefs.getString('temp_unit') ?? 'C';
  dynamicColorEnabledNotifier.value =
      prefs.getBool('dynamic_color_enabled') ?? false;
}
