import 'package:easyweather/services/notify.dart';
import 'package:easyweather/services/weather.dart';
import 'package:flutter/material.dart';
import 'package:easyweather/pages/home/view.dart';
import 'package:get/get.dart';
import 'package:dynamic_color/dynamic_color.dart';

// 启动入口
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 读取并应用主题模式
  String themeMode = await loadThemeMode();

  // 启动后数据读取处理
  Future<String> futureCityName = getCityName();
  wCtr.locality.value = await futureCityName;

  Future<List<String>> futureCityList = getList();
  cityList = await futureCityList;

  runApp(MyApp(initialThemeMode: themeMode));

  // 获取天气
  await WeatherService().getLocationWeather();
}

class MyApp extends StatelessWidget {
  final String initialThemeMode;

  const MyApp({super.key, required this.initialThemeMode});

  @override
  Widget build(BuildContext context) {
    // 获取Material Design Color
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

        // 应用程序总入口
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
