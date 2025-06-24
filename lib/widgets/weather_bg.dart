import 'package:flutter/material.dart';

// 天气渐变背景组件
class WeatherBg extends StatelessWidget {
  final int? weatherCode;
  const WeatherBg({super.key, this.weatherCode});

  @override
  Widget build(BuildContext context) {
    final code = weatherCode;
    LinearGradient gradient;
    if (code == 0) {
      // 晴天
      gradient = const LinearGradient(
        colors: [Color(0xFF64B5F6), Color(0xFFE3F2FD)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else if ([1, 2, 3].contains(code)) {
      // 多云
      gradient = const LinearGradient(
        colors: [Color(0xFF90A4AE), Color(0xFFECEFF1)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else if ([45, 48].contains(code)) {
      // 雾天
      gradient = const LinearGradient(
        colors: [Color(0xFFECEFF1), Color(0xFFB0BEC5)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else if ([51, 53, 55, 56, 57, 61, 63, 65, 66, 67, 80, 81, 82]
        .contains(code)) {
      // 雨天
      gradient = const LinearGradient(
        colors: [Color(0xFF1976D2), Color(0xFF90A4AE)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else if ([71, 73, 75, 77, 85, 86].contains(code)) {
      // 雪天
      gradient = const LinearGradient(
        colors: [Color(0xFFB3E5FC), Color(0xFFE1F5FE)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else if ([95, 96, 99].contains(code)) {
      // 雷暴
      gradient = const LinearGradient(
        colors: [Color(0xFF263238), Color(0xFF607D8B)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else {
      // 默认蓝灰
      gradient = const LinearGradient(
        colors: [Color(0xFF90CAF9), Color(0xFFB0BEC5)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
      ),
    );
  }
}
