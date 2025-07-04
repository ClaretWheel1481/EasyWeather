import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/city.dart';
import '../models/weather.dart';

// 加载缓存的天气数据
Future<WeatherData?> loadCachedWeather(City city,
    {int maxAgeMinutes = 30}) async {
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
    return WeatherData.fromJson(map['data']);
  } catch (_) {
    return null;
  }
}

// 缓存天气数据
Future<void> cacheWeather(City city, WeatherData data) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(
    city.cacheKey,
    json.encode({
      'data': data.toJson(),
      'ts': DateTime.now().millisecondsSinceEpoch,
    }),
  );
}
