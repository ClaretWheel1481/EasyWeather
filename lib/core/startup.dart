import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notifiers.dart';
import 'package:flutter/material.dart';

Future<void> initAppSettings() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  themeModeNotifier.value = ThemeMode.values[prefs.getInt('theme_mode') ?? 0];
  tempUnitNotifier.value = prefs.getString('temp_unit') ?? 'C';
  dynamicColorEnabledNotifier.value =
      prefs.getBool('dynamic_color_enabled') ?? false;

  final systemLocale = PlatformDispatcher.instance.locale;
  if (kDebugMode) {
    debugPrint('systemLocale: $systemLocale');
  }
  if (prefs.containsKey('locale_index')) {
    // 用户已手动设置过语言
    localeIndexNotifier.value = prefs.getInt('locale_index') ?? 0;
  } else {
    if (systemLocale.languageCode == 'en') {
      localeIndexNotifier.value = 0; // 英文
    } else if (systemLocale.toString() == 'zh_CN') {
      localeIndexNotifier.value = 1; // 简体中文
    } else if (systemLocale.toString() == 'zh_TW') {
      localeIndexNotifier.value = 2; // 繁体中文
    } else {
      localeIndexNotifier.value = 0; // 其他默认英文
    }
  }
}
