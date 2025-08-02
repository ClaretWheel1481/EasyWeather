import 'package:flutter/material.dart';

final themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.system);
final tempUnitNotifier = ValueNotifier<String>('C');
final dynamicColorEnabledNotifier = ValueNotifier<bool>(false);
final localeCodeNotifier = ValueNotifier<String>('en');
final weatherSourceNotifier = ValueNotifier<String>('OpenMeteo');
final weatherDataChangedNotifier = ValueNotifier<int>(0);
