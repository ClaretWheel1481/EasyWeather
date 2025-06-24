import 'package:easyweather/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/home/view.dart';
import 'pages/search/view.dart';
import 'pages/settings/view.dart';
import 'package:dynamic_color/dynamic_color.dart';

final themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.system);
final tempUnitNotifier = ValueNotifier<String>('C');
final dynamicColorEnabledNotifier = ValueNotifier<bool>(false);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final mode = ThemeMode.values[prefs.getInt('theme_mode') ?? 2];
  themeModeNotifier.value = mode;
  tempUnitNotifier.value = prefs.getString('temp_unit') ?? 'C';
  runApp(const EasyWeatherApp());
}

class EasyWeatherApp extends StatelessWidget {
  const EasyWeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, mode, _) {
        return ValueListenableBuilder<bool>(
          valueListenable: dynamicColorEnabledNotifier,
          builder: (context, dynamicColorEnabled, __) {
            if (dynamicColorEnabled) {
              return DynamicColorBuilder(
                builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
                  return MaterialApp(
                    title: AppConstants.appName,
                    theme: ThemeData(
                      colorScheme: lightDynamic ??
                          ColorScheme.fromSeed(seedColor: Colors.blue),
                      useMaterial3: true,
                    ),
                    darkTheme: ThemeData(
                      colorScheme: darkDynamic ??
                          ColorScheme.fromSeed(
                              seedColor: Colors.blue,
                              brightness: Brightness.dark),
                      useMaterial3: true,
                    ),
                    themeMode: mode,
                    home: const HomePage(),
                    routes: {
                      '/search': (_) => const SearchPage(),
                      '/settings': (_) => const SettingsPage(),
                    },
                  );
                },
              );
            } else {
              return MaterialApp(
                title: AppConstants.appName,
                theme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
                  useMaterial3: true,
                ),
                darkTheme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(
                      seedColor: Colors.blue, brightness: Brightness.dark),
                  useMaterial3: true,
                ),
                themeMode: mode,
                home: const HomePage(),
                routes: {
                  '/search': (_) => const SearchPage(),
                  '/settings': (_) => const SettingsPage(),
                },
              );
            }
          },
        );
      },
    );
  }
}
