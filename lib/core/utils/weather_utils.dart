import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';

// 天气代码转图标
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

// 天气代码转描述
String weatherDesc(int? code) {
  if (code == null) return 'weatherUnknown';
  switch (code) {
    case 0:
      return 'weatherClear';
    case 1:
    case 2:
    case 3:
      return 'weatherCloudy';
    case 45:
    case 48:
      return 'weatherFoggy';
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
      return 'weatherRainy';
    case 71:
    case 73:
    case 75:
    case 77:
    case 85:
    case 86:
      return 'weatherSnowy';
    case 95:
    case 96:
    case 99:
      return 'weatherThunderstorm';
    default:
      return 'weatherCloudy';
  }
}

// 仅中英文的天气描述
String getWeatherDescForWidget(int code, int lang) {
  final descKey = weatherDesc(code);

  switch (descKey) {
    case 'weatherUnknown':
      return lang == 3 ? '未知' : 'Unknown';
    case 'weatherClear':
      return lang == 3 ? '晴天' : 'Clear';
    case 'weatherCloudy':
      return lang == 3 ? '多云' : 'Cloudy';
    case 'weatherFoggy':
      return lang == 3 ? '雾' : 'Foggy';
    case 'weatherRainy':
      return lang == 3 ? '雨' : 'Rainy';
    case 'weatherSnowy':
      return lang == 3 ? '雪' : 'Snowy';
    case 'weatherThunderstorm':
      return lang == 3 ? '雷暴' : 'Thunderstorm';
    default:
      return lang == 3 ? '未知' : 'Unknown';
  }
}

// 获取国际化的天气描述
String getLocalizedWeatherDesc(BuildContext context, int? code) {
  final l10n = AppLocalizations.of(context);
  final descKey = weatherDesc(code);

  switch (descKey) {
    case 'weatherUnknown':
      return l10n.weatherUnknown;
    case 'weatherClear':
      return l10n.weatherClear;
    case 'weatherCloudy':
      return l10n.weatherCloudy;
    case 'weatherFoggy':
      return l10n.weatherFoggy;
    case 'weatherRainy':
      return l10n.weatherRainy;
    case 'weatherSnowy':
      return l10n.weatherSnowy;
    case 'weatherThunderstorm':
      return l10n.weatherThunderstorm;
    default:
      return l10n.weatherUnknown;
  }
}

// 空气质量等级
enum AirQualityLevel {
  good,
  moderate,
  unhealthyForSensitive,
  unhealthy,
  veryUnhealthy,
  hazardous,
}

// 根据PM2.5和PM10值综合判断空气质量等级
AirQualityLevel getAirQualityLevel({double? pm25, double? pm10}) {
  if (pm25 == null && pm10 == null) return AirQualityLevel.good;

  // 如果只有一个值，使用单个值判断
  if (pm25 == null) {
    return _getAirQualityLevelByPM10(pm10!);
  }
  if (pm10 == null) {
    return _getAirQualityLevelByPM25(pm25);
  }

  // 两个值都存在，综合判断
  final pm25Level = _getAirQualityLevelByPM25(pm25);
  final pm10Level = _getAirQualityLevelByPM10(pm10);

  // 取较差的等级作为最终结果
  return _getWorseLevel(pm25Level, pm10Level);
}

// 根据PM2.5值获取空气质量等级
AirQualityLevel _getAirQualityLevelByPM25(double pm25) {
  if (pm25 <= 12) return AirQualityLevel.good;
  if (pm25 <= 35.4) return AirQualityLevel.moderate;
  if (pm25 <= 55.4) return AirQualityLevel.unhealthyForSensitive;
  if (pm25 <= 150.4) return AirQualityLevel.unhealthy;
  if (pm25 <= 250.4) return AirQualityLevel.veryUnhealthy;
  return AirQualityLevel.hazardous;
}

// 根据PM10值获取空气质量等级
AirQualityLevel _getAirQualityLevelByPM10(double pm10) {
  if (pm10 <= 54) return AirQualityLevel.good;
  if (pm10 <= 154) return AirQualityLevel.moderate;
  if (pm10 <= 254) return AirQualityLevel.unhealthyForSensitive;
  if (pm10 <= 354) return AirQualityLevel.unhealthy;
  if (pm10 <= 424) return AirQualityLevel.veryUnhealthy;
  return AirQualityLevel.hazardous;
}

// 比较两个空气质量等级，返回较差的等级
AirQualityLevel _getWorseLevel(AirQualityLevel level1, AirQualityLevel level2) {
  final levels = [
    AirQualityLevel.good,
    AirQualityLevel.moderate,
    AirQualityLevel.unhealthyForSensitive,
    AirQualityLevel.unhealthy,
    AirQualityLevel.veryUnhealthy,
    AirQualityLevel.hazardous,
  ];

  final index1 = levels.indexOf(level1);
  final index2 = levels.indexOf(level2);

  return levels[index1 > index2 ? index1 : index2];
}

// 获取空气质量等级对应的图标
IconData getAirQualityIcon(AirQualityLevel level) {
  switch (level) {
    case AirQualityLevel.good:
      return Icons.sentiment_very_satisfied;
    case AirQualityLevel.moderate:
      return Icons.sentiment_satisfied;
    case AirQualityLevel.unhealthyForSensitive:
      return Icons.sentiment_neutral;
    case AirQualityLevel.unhealthy:
      return Icons.sentiment_dissatisfied;
    case AirQualityLevel.veryUnhealthy:
      return Icons.sentiment_very_dissatisfied;
    case AirQualityLevel.hazardous:
      return Icons.warning;
  }
}

// 获取国际化的空气质量描述
String getLocalizedAirQualityDesc(BuildContext context, AirQualityLevel level) {
  final l10n = AppLocalizations.of(context);

  switch (level) {
    case AirQualityLevel.good:
      return l10n.airQualityGood;
    case AirQualityLevel.moderate:
      return l10n.airQualityModerate;
    case AirQualityLevel.unhealthyForSensitive:
      return l10n.airQualityUnhealthyForSensitive;
    case AirQualityLevel.unhealthy:
      return l10n.airQualityUnhealthy;
    case AirQualityLevel.veryUnhealthy:
      return l10n.airQualityVeryUnhealthy;
    case AirQualityLevel.hazardous:
      return l10n.airQualityHazardous;
  }
}

// 风向角度转文本
String windDirectionText(double deg) {
  // 0/360为北，顺时针
  const dirs = [
    'windDirectionNorth',
    'windDirectionNortheast',
    'windDirectionEast',
    'windDirectionSoutheast',
    'windDirectionSouth',
    'windDirectionSouthwest',
    'windDirectionWest',
    'windDirectionNorthwest',
    'windDirectionNorth'
  ];
  int idx = ((deg + 22.5) % 360 ~/ 45).toInt();
  return dirs[idx];
}

// 获取国际化的风向描述
String getLocalizedWindDirection(BuildContext context, double deg) {
  final l10n = AppLocalizations.of(context);
  final dirKey = windDirectionText(deg);

  switch (dirKey) {
    case 'windDirectionNorth':
      return l10n.windDirectionNorth;
    case 'windDirectionNortheast':
      return l10n.windDirectionNortheast;
    case 'windDirectionEast':
      return l10n.windDirectionEast;
    case 'windDirectionSoutheast':
      return l10n.windDirectionSoutheast;
    case 'windDirectionSouth':
      return l10n.windDirectionSouth;
    case 'windDirectionSouthwest':
      return l10n.windDirectionSouthwest;
    case 'windDirectionWest':
      return l10n.windDirectionWest;
    case 'windDirectionNorthwest':
      return l10n.windDirectionNorthwest;
    default:
      return l10n.windDirectionNorth;
  }
}
