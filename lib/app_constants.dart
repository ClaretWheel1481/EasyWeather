class AppConstants {
  static const String appName = 'Zephyr';
  static const String appVersion = 'v2.0.2';
  static const String appDescription =
      'Simple and fast real-time weather forecast software.';

  // OpenStreetMap API Url 用于搜索城市
  static const String osmUrl = 'https://nominatim.openstreetmap.org/search';

  // OpenMeteo API Url 用于获取天气数据
  static const String omForecastUrl = 'https://api.open-meteo.com/v1/forecast';
  static const String omAirQualityUrl =
      'https://air-quality-api.open-meteo.com/v1/air-quality';
}
