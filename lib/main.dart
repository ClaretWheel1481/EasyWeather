import 'package:easyweather/utils/function.dart';
import 'package:flutter/material.dart';
import 'package:easyweather/pages/home/view.dart';
import 'package:get/get.dart';
import 'package:dynamic_color/dynamic_color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());

  // 启动后数据读取处理
  Future<String> futureCityName = getCityName();
  controller.locality.value = await futureCityName;

  Future<List<String>> futureCityList = getList();
  cityList = await futureCityList;

  // 优化第一次启动与正常启动
  if (controller.locality.value != '') {
    await getLocationWeather();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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

        return GetMaterialApp(
          theme: ThemeData(
            colorScheme: lightColorScheme,
            useMaterial3: true,
            brightness: Brightness.light,
            fontFamily: "HMOS",
          ),
          darkTheme: ThemeData(
            colorScheme: darkColorScheme,
            useMaterial3: true,
            brightness: Brightness.dark,
            fontFamily: "HMOS",
          ),
          themeMode: ThemeMode.system,
          home: const MyHomePage(),
        );
      },
    );
  }
}
