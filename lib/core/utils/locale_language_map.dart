import '../languages.dart';

// API语言参数的通用映射表（针对qweather与openstreetmap api）
final Map<String, String> localeToApiLang = {
  for (var l in appLanguages) l.code: l.apiLang,
};
