import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zephyr/app.dart';
import 'core/startup.dart';
import 'core/services/native_weather_service.dart';

Future<void> main() async {
  await initAppSettings();

  // 初始化并启动原生天气服务
  try {
    await NativeWeatherService.initialize();
    await NativeWeatherService.startService();
    kDebugMode ? debugPrint('原生天气服务已启动') : null;
  } catch (e) {
    kDebugMode ? debugPrint('原生天气服务启动失败: $e') : null;
  }

  runApp(const ZephyrApp());
}
