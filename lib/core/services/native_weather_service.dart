import 'dart:async';
import 'dart:io';
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
      if (Platform.isAndroid) {
        // Android平台监听事件
        _eventSubscription = _eventChannel.receiveBroadcastStream().listen(
          (dynamic event) {
            if (event == 'FETCH_WEATHER') {
              if (kDebugMode) print('收到Android原生服务天气获取请求');
              WeatherFetchService.forceFetchWeather();
            }
          },
          onError: (error) {
            if (kDebugMode) print('Android原生服务事件监听错误: $error');
          },
        );
      } else if (Platform.isIOS) {
        // iOS平台监听通知
        _eventSubscription = _eventChannel.receiveBroadcastStream().listen(
          (dynamic event) {
            if (event == 'FETCH_WEATHER') {
              if (kDebugMode) print('收到iOS原生服务天气获取请求');
              WeatherFetchService.forceFetchWeather();
            }
          },
          onError: (error) {
            if (kDebugMode) print('iOS原生服务事件监听错误: $error');
          },
        );
      }

      _isInitialized = true;
      if (kDebugMode) print('原生天气服务初始化成功');
    } catch (e) {
      if (kDebugMode) print('原生天气服务初始化失败: $e');
    }
  }

  static Future<void> startService() async {
    try {
      if (Platform.isAndroid) {
        // Android平台启动原生服务
        await _channel.invokeMethod('startService');
        if (kDebugMode) print('Android原生天气服务已启动');
      } else if (Platform.isIOS) {
        // iOS平台启动后台任务
        await _channel.invokeMethod('startBackgroundService');
        if (kDebugMode) print('iOS后台天气服务已启动');
      }
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
