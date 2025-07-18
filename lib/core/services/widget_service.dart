import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather.dart';
import '../models/city.dart';
import '../notifiers.dart';
import 'weather_cache.dart';
import 'package:flutter/widgets.dart';
import 'package:zephyr/l10n/generated/app_localizations.dart';
import '../utils/weather_utils.dart';

class WidgetService {
  static const String _widgetDataKey = 'flutter.weather_widget_data';

  // 更新小部件数据
  // TODO: 后台更新时同时更新小部件
  static Future<void> updateWidget({
    required BuildContext context,
    required City city,
    WeatherData? weatherData,
  }) async {
    try {
      if (weatherData == null) {
        weatherData = await loadCachedWeather(city);
        if (weatherData == null) {
          await _showNoDataWidget(context, city);
          return;
        }
      }

      if (weatherData.current == null) return;

      final current = weatherData.current!;

      // 获取当前语言设置
      final weatherDesc = getLocalizedWeatherDesc(context, current.weatherCode);

      // 根据温度单位格式化温度显示
      final tempUnit = tempUnitNotifier.value;
      String temperature;

      if (tempUnit == 'F') {
        temperature = '${current.temperature.round()}°F';
      } else {
        temperature = '${current.temperature.round()}°C';
      }

      // 准备小部件数据
      final widgetData = {
        'city_name': city.name,
        'weather_desc': weatherDesc,
        'temperature': temperature,
        'weather_code': current.weatherCode,
        'temp_unit': tempUnit,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      // 保存到SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final jsonData = jsonEncode(widgetData);
      await prefs.setString(_widgetDataKey, jsonData);

      try {
        await HomeWidget.saveWidgetData('city_name', widgetData['city_name']);
        await HomeWidget.saveWidgetData(
            'weather_desc', widgetData['weather_desc']);
        await HomeWidget.saveWidgetData(
            'temperature', widgetData['temperature']);
        await HomeWidget.saveWidgetData(
            'weather_code', widgetData['weather_code']);
        await HomeWidget.saveWidgetData('temp_unit', widgetData['temp_unit']);
        await HomeWidget.saveWidgetData('timestamp', widgetData['timestamp']);

        await HomeWidget.updateWidget(
          androidName: 'WeatherWidgetProvider',
          iOSName: 'WeatherWidget',
        );
      } catch (e) {
        if (kDebugMode) {
          print('HomeWidget update failed: $e');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating widget: $e');
      }
    }
  }

  // 显示无数据时的提示小部件
  static Future<void> _showNoDataWidget(BuildContext context, City city) async {
    try {
      final l10n = AppLocalizations.of(context);
      final cityName = l10n.addCity;
      final weatherDesc = l10n.weatherDataError;
      final temperature = '--';

      // 获取当前温度单位设置
      final tempUnit = tempUnitNotifier.value;

      final widgetData = {
        'city_name': cityName,
        'weather_desc': weatherDesc,
        'temperature': temperature,
        'weather_code': 0,
        'temp_unit': tempUnit,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      final prefs = await SharedPreferences.getInstance();
      final jsonData = jsonEncode(widgetData);
      await prefs.setString(_widgetDataKey, jsonData);

      try {
        await HomeWidget.saveWidgetData('city_name', widgetData['city_name']);
        await HomeWidget.saveWidgetData(
            'weather_desc', widgetData['weather_desc']);
        await HomeWidget.saveWidgetData(
            'temperature', widgetData['temperature']);
        await HomeWidget.saveWidgetData(
            'weather_code', widgetData['weather_code']);
        await HomeWidget.saveWidgetData('temp_unit', widgetData['temp_unit']);
        await HomeWidget.saveWidgetData('timestamp', widgetData['timestamp']);

        await HomeWidget.updateWidget(
          androidName: 'WeatherWidgetProvider',
          iOSName: 'WeatherWidget',
        );
      } catch (e) {
        if (kDebugMode) {
          print('HomeWidget update failed: $e');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error showing no data widget: $e');
      }
    }
  }
}
