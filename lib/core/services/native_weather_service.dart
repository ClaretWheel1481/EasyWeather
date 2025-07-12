import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:zephyr/core/services/weather_fetch_service.dart';

class NativeWeatherService {
  static const MethodChannel _channel = MethodChannel('weather_service');
  static const EventChannel _eventChannel =
      EventChannel('weather_service_events');
  static StreamSubscription? _eventSubscription;
  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _eventSubscription = _eventChannel.receiveBroadcastStream().listen(
        (dynamic event) {
          if (event == 'FETCH_WEATHER') {
            if (kDebugMode) print('收到原生服务天气获取请求');
            WeatherFetchService.forceFetchWeather();
          }
        },
        onError: (error) {
          if (kDebugMode) print('原生服务事件监听错误: $error');
        },
      );

      _isInitialized = true;
      if (kDebugMode) print('原生天气服务初始化成功');
    } catch (e) {
      if (kDebugMode) print('原生天气服务初始化失败: $e');
    }
  }

  static Future<void> startService() async {
    try {
      await _channel.invokeMethod('startService');
      if (kDebugMode) print('原生天气服务已启动');
    } catch (e) {
      if (kDebugMode) print('启动原生天气服务失败: $e');
    }
  }

  static void dispose() {
    _eventSubscription?.cancel();
    _eventSubscription = null;
    _isInitialized = false;
  }
}
