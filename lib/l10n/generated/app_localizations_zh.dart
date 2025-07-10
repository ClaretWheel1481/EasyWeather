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
  String get light => '浅色';

  @override
  String get dark => '深色';

  @override
  String get temperatureUnit => '温度单位';

  @override
  String get celsius => '摄氏度 (°C)';

  @override
  String get fahrenheit => '华氏度 (°F)';

  @override
  String get cityManager => '城市管理';

  @override
  String get cities => '个城市';

  @override
  String get main => '主城市';

  @override
  String get noCitiesAdded => '暂无已添加的城市';

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
  String get uvIndex => '紫外线指数';

  @override
  String get addCity => '添加城市';

  @override
  String get addByLocation => '定位添加';

  @override
  String get locating => '正在获取位置信息...';

  @override
  String get locationPermissionDenied => '无法获取定位权限或定位服务未开启';

  @override
  String get locationNotRecognized => '无法识别当前位置';

  @override
  String get locatingSuccess => '获取位置信息成功，请稍后...';

  @override
  String get airQuality => '空气质量';

  @override
  String get airQualityGood => '优';

  @override
  String get airQualityModerate => '良';

  @override
  String get airQualityUnhealthyForSensitive => '一般';

  @override
  String get airQualityUnhealthy => '较差';

  @override
  String get airQualityVeryUnhealthy => '极差';

  @override
  String get airQualityHazardous => '危险';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw(): super('zh_TW');

  @override
  String get about => '關於';

  @override
  String get themeMode => '主題模式';

  @override
  String get system => '系統';

  @override
  String get light => '淺色';

  @override
  String get dark => '深色';

  @override
  String get temperatureUnit => '溫度單位';

  @override
  String get celsius => '攝氏度 (°C)';

  @override
  String get fahrenheit => '華氏度 (°F)';

  @override
  String get cityManager => '城市管理';

  @override
  String get cities => '个城市';

  @override
  String get main => '主城市';

  @override
  String get noCitiesAdded => '暫無已添加的城市';

  @override
  String get confirm => '確認';

  @override
  String deleteCityMessage(String cityName) {
    return '確定要刪除 \"$cityName\" 嗎？';
  }

  @override
  String get cancel => '取消';

  @override
  String get delete => '刪除';

  @override
  String get search => '搜索';

  @override
  String get searchHint => '輸入城市名稱...';

  @override
  String get searchHintOnSurface => '輸入城市名稱以開始搜索';

  @override
  String get noResults => '未找到結果';

  @override
  String get searchError => '搜索錯誤';

  @override
  String get weatherUnknown => '未知';

  @override
  String get weatherClear => '晴';

  @override
  String get weatherCloudy => '多雲';

  @override
  String get weatherFoggy => '有霧';

  @override
  String get weatherRainy => '雨';

  @override
  String get weatherSnowy => '雪';

  @override
  String get weatherThunderstorm => '雷暴';

  @override
  String get windDirectionNorth => '北';

  @override
  String get windDirectionNortheast => '東北';

  @override
  String get windDirectionEast => '東';

  @override
  String get windDirectionSoutheast => '東南';

  @override
  String get windDirectionSouth => '南';

  @override
  String get windDirectionSouthwest => '西南';

  @override
  String get windDirectionWest => '西';

  @override
  String get windDirectionNorthwest => '西北';

  @override
  String get humidity => '濕度';

  @override
  String get pressure => '氣壓';

  @override
  String get visibility => '能見度';

  @override
  String get feelsLike => '體感';

  @override
  String get windSpeed => '風速';

  @override
  String get windDirection => '風向';

  @override
  String get precipitation => '降水量';

  @override
  String get hourlyForecast => '逐小時預報';

  @override
  String get next7Days => '未來7天';

  @override
  String get detailedData => '詳細數據';

  @override
  String get settings => '設置';

  @override
  String get language => '語言';

  @override
  String get monetColor => 'Monet取色';

  @override
  String get retry => '重試';

  @override
  String get weatherDataError => '天氣數據加載失敗';

  @override
  String get uvIndex => '紫外線指數';

  @override
  String get addCity => '添加城市';

  @override
  String get addByLocation => '定位添加';

  @override
  String get locating => '正在獲取位置信息...';

  @override
  String get locationPermissionDenied => '無法獲取定位權限或定位服務未開啟';

  @override
  String get locationNotRecognized => '無法識別當前位置';

  @override
  String get locatingSuccess => '獲取位置信息成功，請稍後...';

  @override
  String get airQuality => '空氣質量';

  @override
  String get airQualityGood => '優';

  @override
  String get airQualityModerate => '良';

  @override
  String get airQualityUnhealthyForSensitive => '一般';

  @override
  String get airQualityUnhealthy => '較差';

  @override
  String get airQualityVeryUnhealthy => '極差';

  @override
  String get airQualityHazardous => '危險';
}
