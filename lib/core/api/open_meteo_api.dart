import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class OpenMeteoApi {
  static const String baseUrl = 'https://api.open-meteo.com/v1/forecast';

  /// 获取天气数据
  static Future<WeatherData?> fetchWeather({
    required double latitude,
    required double longitude,
    String lang = 'zh',
    String units = 'metric',
  }) async {
    final url = Uri.parse(
        '$baseUrl?latitude=$latitude&longitude=$longitude&current=apparent_temperature,temperature_2m,weather_code,relative_humidity_2m,wind_speed_10m&hourly=weathercode,temperature_2m,precipitation,cloudcover,windspeed_10m,winddirection_10m,relative_humidity_2m,visibility&daily=temperature_2m_max,temperature_2m_min,weathercode,precipitation_sum,windspeed_10m_max,winddirection_10m_dominant&timezone=auto&lang=$lang&temperature_unit=${units == 'imperial' ? 'fahrenheit' : 'celsius'}');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      kDebugMode ? debugPrint(response.body) : null;
      return WeatherData.fromJson(json.decode(response.body));
    }
    return null;
  }
}
