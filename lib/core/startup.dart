import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notifiers.dart';
import 'package:flutter/material.dart';

const Map<String, int> _systemLocaleToAppLocaleIndex = {
  'en': 0,
  'es': 1,
  'it': 2,
  'zh': 3,
  'zh_CN': 3,
  'zh_TW': 4,
};

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
    // 根据系统语言自动设置默认语言
    final localeString = systemLocale.toString();
    final languageCode = systemLocale.languageCode;

    // 优先使用完整locale字符串匹配，然后回退到语言代码匹配
    final localeIndex = _systemLocaleToAppLocaleIndex[localeString] ??
        _systemLocaleToAppLocaleIndex[languageCode] ??
        0; // 默认英文

    localeIndexNotifier.value = localeIndex;
  }
}
