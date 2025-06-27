// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get about => 'About';

  @override
  String get themeMode => 'Theme Mode';

  @override
  String get system => 'System';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get temperatureUnit => 'Temperature Unit';

  @override
  String get celsius => 'Celsius (°C)';

  @override
  String get fahrenheit => 'Fahrenheit (°F)';

  @override
  String get cityManager => 'City Manager';

  @override
  String get cities => 'cities';

  @override
  String get main => 'Main';

  @override
  String get noCitiesAdded => 'No cities added';

  @override
  String get confirm => 'Confirm';

  @override
  String deleteCityMessage(String cityName) {
    return 'Are you sure you want to delete \"$cityName\"?';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get search => 'Search';

  @override
  String get searchHint => 'Enter city name...';

  @override
  String get searchHintOnSurface => 'Enter city name to start searching';

  @override
  String get noResults => 'No results found';

  @override
  String get searchError => 'Search error';

  @override
  String get weatherUnknown => 'Unknown';

  @override
  String get weatherClear => 'Clear';

  @override
  String get weatherCloudy => 'Cloudy';

  @override
  String get weatherFoggy => 'Foggy';

  @override
  String get weatherRainy => 'Rainy';

  @override
  String get weatherSnowy => 'Snowy';

  @override
  String get weatherThunderstorm => 'Thunderstorm';

  @override
  String get windDirectionNorth => 'North';

  @override
  String get windDirectionNortheast => 'Northeast';

  @override
  String get windDirectionEast => 'East';

  @override
  String get windDirectionSoutheast => 'Southeast';

  @override
  String get windDirectionSouth => 'South';

  @override
  String get windDirectionSouthwest => 'Southwest';

  @override
  String get windDirectionWest => 'West';

  @override
  String get windDirectionNorthwest => 'Northwest';

  @override
  String get humidity => 'Humidity';

  @override
  String get pressure => 'Pressure';

  @override
  String get visibility => 'Visibility';

  @override
  String get feelsLike => 'Feels Like';

  @override
  String get windSpeed => 'Wind Speed';

  @override
  String get windDirection => 'Wind Direction';

  @override
  String get precipitation => 'Precipitation';

  @override
  String get hourlyForecast => 'Hourly Forecast';

  @override
  String get next7Days => 'Next 7 Days';

  @override
  String get detailedData => 'Detailed Data';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get monetColor => 'Monet Color';

  @override
  String get retry => 'Retry';

  @override
  String get weatherDataError => 'Weather data loading failed';

  @override
  String get surfacePressure => 'Surface Pressure';

  @override
  String get uvIndex => 'UV Index';

  @override
  String get addCity => 'Add City';

  @override
  String get addByLocation => 'Add by Location';

  @override
  String get locating => 'Getting location information...';

  @override
  String get locationPermissionDenied => 'Unable to get location permission or location service is disabled';

  @override
  String get locationNotRecognized => 'Unable to recognize the current location';

  @override
  String get locatingSuccess => 'Location obtained successfully, please wait...';

  @override
  String get airQuality => 'Air Quality';

  @override
  String get airQualityGood => 'Good';

  @override
  String get airQualityModerate => 'Moderate';

  @override
  String get airQualityUnhealthyForSensitive => 'Fair';

  @override
  String get airQualityUnhealthy => 'Poor';

  @override
  String get airQualityVeryUnhealthy => 'Very Poor';

  @override
  String get airQualityHazardous => 'Hazardous';
}
