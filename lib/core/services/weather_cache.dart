import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/city.dart';
import '../models/weather.dart';
import '../models/weather_warning.dart';

// 加载缓存的天气数据(缓存13分钟避免后台刷新服务仍然加载缓存数据)
Future<Map<String, dynamic>?> loadCachedWeather(City city,
    {int maxAgeMinutes = 13}) async {
  final prefs = await SharedPreferences.getInstance();
  final str = prefs.getString(city.cacheKey);
  if (str == null) return null;
  final map = json.decode(str);
  final ts = map['ts'] as int?;
  if (ts != null &&
      DateTime.now().millisecondsSinceEpoch - ts > maxAgeMinutes * 60000) {
    return null;
  }
  try {
    final weather = WeatherData.fromJson(map['data']);
    final warningsRaw = map['warnings'] as List<dynamic>?;
    final warnings = warningsRaw == null
        ? <WeatherWarning>[]
        : warningsRaw.map((e) => WeatherWarning.fromJson(e)).toList();
    return {'weather': weather, 'warnings': warnings};
  } catch (_) {
    return null;
  }
}

// 缓存天气数据
Future<void> cacheWeather(
    City city, WeatherData data, List<WeatherWarning> warnings) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(
    city.cacheKey,
    json.encode({
      'data': data.toJson(),
      'warnings': warnings.map((w) => w.toJson()).toList(),
      'ts': DateTime.now().millisecondsSinceEpoch,
    }),
  );
}
