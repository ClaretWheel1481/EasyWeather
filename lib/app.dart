import 'package:flutter/material.dart';
import 'package:easyweather/app_constants.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'l10n/generated/app_localizations.dart';
import 'core/notifiers.dart';
import 'pages/home/view.dart';
import 'pages/search/view.dart';
import 'pages/settings/view.dart';

// 支持的语言列表
final List<Locale> supportedLocales = [
  const Locale('zh', 'CN'),
  const Locale('en', 'US'),
];

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
            return ValueListenableBuilder<int>(
              valueListenable: localeIndexNotifier,
              builder: (context, localeIndex, _) {
                final locale = supportedLocales[localeIndex];
                if (dynamicColorEnabled) {
                  return DynamicColorBuilder(
                    builder:
                        (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
                      return MaterialApp(
                        title: AppConstants.appName,
                        locale: locale,
                        supportedLocales: supportedLocales,
                        localizationsDelegates:
                            AppLocalizations.localizationsDelegates,
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
                    locale: locale,
                    supportedLocales: supportedLocales,
                    localizationsDelegates:
                        AppLocalizations.localizationsDelegates,
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
      },
    );
  }
}
