import 'package:flutter/material.dart';
import 'package:zephyr/app_constants.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'l10n/generated/app_localizations.dart';
import 'core/notifiers.dart';
import 'pages/home/view.dart';
import 'pages/search/view.dart';
import 'pages/settings/view.dart';
import 'core/languages.dart';

// 支持的语言列表
final List<Locale> supportedLocales =
    appLanguages.map((e) => e.locale).toList();

class ZephyrApp extends StatefulWidget {
  const ZephyrApp({super.key});

  @override
  State<ZephyrApp> createState() => _ZephyrAppState();
}

class _ZephyrAppState extends State<ZephyrApp> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, mode, _) {
        return ValueListenableBuilder<bool>(
          valueListenable: dynamicColorEnabledNotifier,
          builder: (context, dynamicColorEnabled, __) {
            return ValueListenableBuilder<String>(
              valueListenable: localeCodeNotifier,
              builder: (context, localeCode, __) {
                final locale =
                    appLanguages.firstWhere((l) => l.code == localeCode).locale;
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
                          pageTransitionsTheme: const PageTransitionsTheme(
                            builders: {
                              TargetPlatform.android:
                                  CupertinoPageTransitionsBuilder(),
                              TargetPlatform.iOS:
                                  CupertinoPageTransitionsBuilder(),
                            },
                          ),
                        ),
                        darkTheme: ThemeData(
                          colorScheme: darkDynamic ??
                              ColorScheme.fromSeed(
                                  seedColor: Colors.blue,
                                  brightness: Brightness.dark),
                          useMaterial3: true,
                          pageTransitionsTheme: const PageTransitionsTheme(
                            builders: {
                              TargetPlatform.android:
                                  CupertinoPageTransitionsBuilder(),
                              TargetPlatform.iOS:
                                  CupertinoPageTransitionsBuilder(),
                            },
                          ),
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
                      pageTransitionsTheme: const PageTransitionsTheme(
                        builders: {
                          TargetPlatform.android:
                              CupertinoPageTransitionsBuilder(),
                          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                        },
                      ),
                    ),
                    darkTheme: ThemeData(
                      colorScheme: ColorScheme.fromSeed(
                          seedColor: Colors.blue, brightness: Brightness.dark),
                      useMaterial3: true,
                      pageTransitionsTheme: const PageTransitionsTheme(
                        builders: {
                          TargetPlatform.android:
                              CupertinoPageTransitionsBuilder(),
                          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                        },
                      ),
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
