import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'core/startup.dart';
import 'app.dart';
import 'core/services/weather_fetch_timer_service.dart';

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(WeatherTaskHandler());
}

class WeatherTaskHandler extends TaskHandler {
  Timer? _timer;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    // 启动时每5分钟拉一次天气
    _timer = Timer.periodic(const Duration(minutes: 5), (timer) async {
      await WeatherFetchTimerService.fetchAndCacheWeather();
    });
  }

  @override
  void onRepeatEvent(DateTime timestamp) async {}

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void onNotificationButtonPressed(String id) {}

  @override
  void onNotificationPressed() {
    FlutterForegroundTask.launchApp();
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initAppSettings();
  FlutterForegroundTask.initCommunicationPort();
  runApp(const ZephyrAppWithForegroundTask());
}

class ZephyrAppWithForegroundTask extends StatelessWidget {
  const ZephyrAppWithForegroundTask({super.key});

  @override
  Widget build(BuildContext context) {
    return ZephyrAppLauncher();
  }
}

class ZephyrAppLauncher extends StatefulWidget {
  @override
  State<ZephyrAppLauncher> createState() => _ZephyrAppLauncherState();
}

class _ZephyrAppLauncherState extends State<ZephyrAppLauncher> {
  @override
  void initState() {
    super.initState();
    _startForegroundTask();
  }

  void _startForegroundTask() async {
    await FlutterForegroundTask.startService(
      notificationTitle: '天气服务运行中',
      notificationText: '每5分钟自动获取天气',
      callback: startCallback,
      serviceTypes: [ForegroundServiceTypes.dataSync],
    );
  }

  @override
  Widget build(BuildContext context) {
    return const ZephyrApp();
  }
}
