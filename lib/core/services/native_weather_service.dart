import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:zephyr/core/services/weather_fetch_service.dart';

class NativeWeatherService {
  static const EventChannel _eventChannel =
      EventChannel('weather_service_events');
  static StreamSubscription? _eventSubscription;
  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      if (Platform.isAndroid) {
        // Android平台监听事件
        _eventSubscription = _eventChannel.receiveBroadcastStream().listen(
          (dynamic event) {
            if (event == 'FETCH_WEATHER') {
              if (kDebugMode) debugPrint('收到Android原生服务天气获取请求');
              WeatherFetchService.forceFetchWeather();
            }
          },
          onError: (error) {
            if (kDebugMode) debugPrint('Android原生服务事件监听错误: $error');
          },
        );
      } else if (Platform.isIOS) {
        // iOS平台监听通知
        _eventSubscription = _eventChannel.receiveBroadcastStream().listen(
          (dynamic event) {
            if (event == 'FETCH_WEATHER') {
              if (kDebugMode) debugPrint('收到iOS原生服务天气获取请求');
              WeatherFetchService.forceFetchWeather();
            }
          },
          onError: (error) {
            if (kDebugMode) debugPrint('iOS原生服务事件监听错误: $error');
          },
        );
      }

      _isInitialized = true;
      if (kDebugMode) debugPrint('原生天气服务初始化成功');
    } catch (e) {
      if (kDebugMode) debugPrint('原生天气服务初始化失败: $e');
    }
  }

  static void dispose() {
    _eventSubscription?.cancel();
    _eventSubscription = null;
    _isInitialized = false;
  }
}
