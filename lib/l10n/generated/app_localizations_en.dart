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
  String get cityManager => 'City Manager';

  @override
  String get cities => 'cities';

  @override
  String get main => 'Main';

  @override
  String get noCitiesAdded => 'No cities added';

  @override
  String deleteCityMessage(String cityName) {
    return 'Are you sure you want to delete \"$cityName\"?';
  }

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
  String get detailedData => 'Details';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get monetColor => 'Dynamic Color';

  @override
  String get retry => 'Retry';

  @override
  String get weatherDataError => 'Weather data loading failed';

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

  @override
  String get addHomeWidget => 'Add Desktop Widget';

  @override
  String get ignoreBatteryOptimization => 'Ignore Battery Optimization';

  @override
  String get iBODesc => 'Allows Zephyr to update weather data in the background';

  @override
  String get iBODisabled => 'Battery Optimization is disabled';

  @override
  String get starUs => 'Star us on GitHub';

  @override
  String get alert => 'Alerts';

  @override
  String get hourly_windSpeed => 'Hourly wind speed';

  @override
  String get hourly_windSpeed_Desc => 'Hourly wind speed, 10m represents wind speed at 10 meters above the ground, and so on. You can manually slide the chart to see detailed wind speed data per hour.';

  @override
  String get hourly_pressure => 'Hourly air pressure';

  @override
  String get hourly_pressure_Desc => 'Hourly air pressure at sea level and surface pressure at ground level, hPa is the unit of air pressure. You can manually slide the chart to see detailed hourly barometric pressure data.';
}
