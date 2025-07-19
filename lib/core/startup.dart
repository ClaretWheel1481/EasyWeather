import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notifiers.dart';
import 'package:flutter/material.dart';
import 'languages.dart';

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

  if (prefs.containsKey('locale_code')) {
    // 用户已手动设置过语言
    localeCodeNotifier.value = prefs.getString('locale_code') ?? 'en';
  } else {
    // 根据系统语言自动设置默认语言
    final localeString = systemLocale.toString();
    final languageCode = systemLocale.languageCode;

    // 优先使用完整locale字符串匹配，然后回退到语言代码匹配
    final matched = appLanguages.firstWhere(
      (l) => l.code == localeString || l.code == languageCode,
      orElse: () => appLanguages.firstWhere((l) => l.code == 'en'),
    );
    localeCodeNotifier.value = matched.code;
  }
}
