import 'package:flutter/material.dart';

final themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.system);
final tempUnitNotifier = ValueNotifier<String>('C');
final dynamicColorEnabledNotifier = ValueNotifier<bool>(false);
final ValueNotifier<int> localeIndexNotifier = ValueNotifier(0);
