import 'package:flutter/material.dart';

/// 天气代码转图标
IconData weatherIcon(int? code) {
  if (code == null) return Icons.help_outline;
  if (code == 0) return Icons.wb_sunny;
  if ([1, 2, 3].contains(code)) return Icons.cloud;
  if ([45, 48].contains(code)) return Icons.foggy;
  if ([51, 53, 55, 56, 57, 61, 63, 65, 66, 67, 80, 81, 82].contains(code)) {
    return Icons.grain;
  }
  if ([71, 73, 75, 77, 85, 86].contains(code)) return Icons.ac_unit;
  if ([95, 96, 99].contains(code)) return Icons.flash_on;
  return Icons.cloud_queue;
}

/// 天气代码转描述
String weatherDesc(int? code) {
  if (code == null) return '未知';
  switch (code) {
    case 0:
      return '晴';
    case 1:
    case 2:
    case 3:
      return '多云';
    case 45:
    case 48:
      return '有雾';
    case 51:
    case 53:
    case 55:
    case 56:
    case 57:
    case 61:
    case 63:
    case 65:
    case 66:
    case 67:
    case 80:
    case 81:
    case 82:
      return '雨';
    case 71:
    case 73:
    case 75:
    case 77:
    case 85:
    case 86:
      return '雪';
    case 95:
    case 96:
    case 99:
      return '雷暴';
    default:
      return '多云';
  }
}

/// 风向角度转文本
String windDirectionText(double deg) {
  // 0/360为北，顺时针
  const dirs = ['北', '东北', '东', '东南', '南', '西南', '西', '西北', '北'];
  int idx = ((deg + 22.5) % 360 ~/ 45).toInt();
  return dirs[idx];
}
