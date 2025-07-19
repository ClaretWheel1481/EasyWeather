import 'package:flutter/material.dart';

final themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.system);
final tempUnitNotifier = ValueNotifier<String>('C');
final dynamicColorEnabledNotifier = ValueNotifier<bool>(false);
final ValueNotifier<String> localeCodeNotifier = ValueNotifier('en');
