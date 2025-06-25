// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get about => '关于';

  @override
  String get themeMode => '主题模式';

  @override
  String get system => '系统';

  @override
  String get light => '明亮';

  @override
  String get dark => '暗色';

  @override
  String get temperatureUnit => '温度单位';

  @override
  String get celsius => '摄氏度 (°C)';

  @override
  String get fahrenheit => '华氏度 (°F)';

  @override
  String get cityManager => '城市管理';

  @override
  String get noCitiesAdded => '暂无已添加城市';

  @override
  String get confirm => '确认';

  @override
  String deleteCityMessage(String cityName) {
    return '确定要删除 \"$cityName\" 吗？';
  }

  @override
  String get cancel => '取消';

  @override
  String get delete => '删除';

  @override
  String get search => '搜索';

  @override
  String get searchHint => '输入城市名称...';

  @override
  String get searchHintOnSurface => '输入城市名称以开始搜索';

  @override
  String get noResults => '未找到结果';

  @override
  String get searchError => '搜索错误';

  @override
  String get weatherUnknown => '未知';

  @override
  String get weatherClear => '晴';

  @override
  String get weatherCloudy => '多云';

  @override
  String get weatherFoggy => '有雾';

  @override
  String get weatherRainy => '雨';

  @override
  String get weatherSnowy => '雪';

  @override
  String get weatherThunderstorm => '雷暴';

  @override
  String get windDirectionNorth => '北';

  @override
  String get windDirectionNortheast => '东北';

  @override
  String get windDirectionEast => '东';

  @override
  String get windDirectionSoutheast => '东南';

  @override
  String get windDirectionSouth => '南';

  @override
  String get windDirectionSouthwest => '西南';

  @override
  String get windDirectionWest => '西';

  @override
  String get windDirectionNorthwest => '西北';

  @override
  String get humidity => '湿度';

  @override
  String get pressure => '气压';

  @override
  String get visibility => '能见度';

  @override
  String get feelsLike => '体感';

  @override
  String get windSpeed => '风速';

  @override
  String get windDirection => '风向';

  @override
  String get precipitation => '降水量';

  @override
  String get hourlyForecast => '逐小时预报';

  @override
  String get next7Days => '未来7天';

  @override
  String get detailedData => '详细数据';

  @override
  String get settings => '设置';

  @override
  String get language => '语言';

  @override
  String get monetColor => 'Monet取色';

  @override
  String get retry => '重试';

  @override
  String get weatherDataError => '天气数据加载失败';

  @override
  String get surfacePressure => '气压';

  @override
  String get uvIndex => '紫外线指数';

  @override
  String get addCity => 'Add City';
}
