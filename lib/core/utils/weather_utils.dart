import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';

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

/// 天气代码转描述 - 现在通过国际化处理
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

/// 获取国际化的天气描述
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

/// 风向角度转文本 - 现在通过国际化处理
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

/// 获取国际化的风向描述
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
