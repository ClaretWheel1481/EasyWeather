import 'package:easyweather/services/notify.dart';
import 'package:easyweather/services/weather.dart';
import 'package:easyweather/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:easyweather/pages/home/view.dart';
import 'package:get/get.dart';
import 'package:dynamic_color/dynamic_color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 读取并应用主题模式
  String themeMode = await loadThemeMode();

  runApp(MyApp(initialThemeMode: themeMode));

  // 获取Token并保存
  await getTokenAndSave();

  // 启动后数据读取处理
  Future<String> futureCityName = getCityName();
  wCtr.locality.value = await futureCityName;

  Future<List<String>> futureCityList = getList();
  cityList = await futureCityList;
}

class MyApp extends StatelessWidget {
  final String initialThemeMode;

  const MyApp({super.key, required this.initialThemeMode});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightColorScheme;
        ColorScheme darkColorScheme;

        if (lightDynamic != null && darkDynamic != null) {
          lightColorScheme = lightDynamic.harmonized();
          darkColorScheme = darkDynamic.harmonized();
        } else {
          lightColorScheme = ColorScheme.fromSwatch(primarySwatch: Colors.blue);
          darkColorScheme = ColorScheme.fromSwatch(
              primarySwatch: Colors.blue, brightness: Brightness.dark);
        }

        ThemeMode themeMode;
        if (initialThemeMode == 'light') {
          themeMode = ThemeMode.light;
        } else if (initialThemeMode == 'dark') {
          themeMode = ThemeMode.dark;
        } else {
          themeMode = ThemeMode.system;
        }

        return GetMaterialApp(
          scaffoldMessengerKey: scaffoldMessengerKey,
          theme: ThemeData(
            colorScheme: lightColorScheme,
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            colorScheme: darkColorScheme,
            brightness: Brightness.dark,
          ),
          themeMode: themeMode,
          home: const MyHomePage(),
        );
      },
    );
  }
}
