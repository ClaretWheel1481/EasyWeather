import 'package:flutter/material.dart';

class AppLanguage {
  final String code;
  final Locale locale;
  final String name;
  final String apiLang;

  const AppLanguage({
    required this.code,
    required this.locale,
    required this.name,
    required this.apiLang,
  });
}

const List<AppLanguage> appLanguages = [
  AppLanguage(
    code: 'de',
    locale: Locale('de'),
    name: 'Deutsch',
    apiLang: 'de',
  ),
  AppLanguage(
    code: 'en',
    locale: Locale('en'),
    name: 'English',
    apiLang: 'en',
  ),
  AppLanguage(
    code: 'es',
    locale: Locale('es'),
    name: 'Español',
    apiLang: 'es',
  ),
  AppLanguage(
      code: 'fr', locale: Locale('fr'), name: 'Français', apiLang: 'fr'),
  AppLanguage(
    code: 'it',
    locale: Locale('it'),
    name: 'Italiano',
    apiLang: 'it',
  ),
  AppLanguage(
    code: 'zh_CN',
    locale: Locale('zh', 'CN'),
    name: '简体中文',
    apiLang: 'zh-hans',
  ),
  AppLanguage(
    code: 'zh_TW',
    locale: Locale('zh', 'TW'),
    name: '繁體中文',
    apiLang: 'zh-hant',
  ),
];
