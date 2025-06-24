class WeatherData {
  final CurrentWeather? current;
  final List<HourlyWeather> hourly;
  final List<DailyWeather> daily;

  WeatherData({this.current, required this.hourly, required this.daily});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final current = json['current'] != null
        ? CurrentWeather.fromJson(
            json['current'], json['hourly']?['visibility']?[0])
        : null;
    final hourlyList = <HourlyWeather>[];
    if (json['hourly'] != null && json['hourly']['time'] != null) {
      final times = List<String>.from(json['hourly']['time']);
      for (int i = 0; i < times.length; i++) {
        hourlyList.add(HourlyWeather(
          time: times[i],
          temperature: (json['hourly']['temperature_2m']?[i])?.toDouble(),
          weatherCode: json['hourly']['weathercode']?[i],
          precipitation: (json['hourly']['precipitation']?[i])?.toDouble(),
          cloudCover: (json['hourly']['cloudcover']?[i])?.toDouble(),
          windSpeed: (json['hourly']['windspeed_10m']?[i])?.toDouble(),
          windDirection: (json['hourly']['winddirection_10m']?[i])?.toDouble(),
          visibility: (json['hourly']['visibility']?[i])?.toDouble(),
        ));
      }
    }
    final dailyList = <DailyWeather>[];
    if (json['daily'] != null && json['daily']['time'] != null) {
      final times = List<String>.from(json['daily']['time']);
      for (int i = 0; i < times.length; i++) {
        dailyList.add(DailyWeather(
          date: times[i],
          tempMax: (json['daily']['temperature_2m_max']?[i])?.toDouble(),
          tempMin: (json['daily']['temperature_2m_min']?[i])?.toDouble(),
          weatherCode: json['daily']['weathercode']?[i],
          precipitation: (json['daily']['precipitation_sum']?[i])?.toDouble(),
          windSpeedMax: (json['daily']['windspeed_10m_max']?[i])?.toDouble(),
          windDirection:
              (json['daily']['winddirection_10m_dominant']?[i])?.toDouble(),
        ));
      }
    }
    return WeatherData(current: current, hourly: hourlyList, daily: dailyList);
  }

  Map<String, dynamic> toJson() => {
        'current': current?.toJson(),
        'hourly': {
          'time': hourly.map((e) => e.time).toList(),
          'temperature_2m': hourly.map((e) => e.temperature).toList(),
          'weathercode': hourly.map((e) => e.weatherCode).toList(),
          'precipitation': hourly.map((e) => e.precipitation).toList(),
          'cloudcover': hourly.map((e) => e.cloudCover).toList(),
          'windspeed_10m': hourly.map((e) => e.windSpeed).toList(),
          'winddirection_10m': hourly.map((e) => e.windDirection).toList(),
          'relative_humidity_2m': hourly.map((e) => e.humidity).toList(),
          'visibility': hourly.map((e) => e.visibility).toList(),
        },
        'daily': {
          'time': daily.map((e) => e.date).toList(),
          'temperature_2m_max': daily.map((e) => e.tempMax).toList(),
          'temperature_2m_min': daily.map((e) => e.tempMin).toList(),
          'weathercode': daily.map((e) => e.weatherCode).toList(),
          'precipitation_sum': daily.map((e) => e.precipitation).toList(),
          'windspeed_10m_max': daily.map((e) => e.windSpeedMax).toList(),
          'winddirection_10m_dominant':
              daily.map((e) => e.windDirection).toList(),
        },
      };
}

class CurrentWeather {
  final double temperature;
  final int weatherCode;
  final double windSpeed;
  final double? windDirection;
  final double? apparentTemperature;
  final double? visibility;
  final double? humidity;

  CurrentWeather({
    required this.temperature,
    required this.weatherCode,
    required this.windSpeed,
    this.windDirection,
    this.apparentTemperature,
    this.visibility,
    this.humidity,
  });

  factory CurrentWeather.fromJson(
      Map<String, dynamic> json, double? visibility) {
    return CurrentWeather(
      temperature: (json['temperature_2m'] ?? 0).toDouble(),
      weatherCode: json['weathercode'] ?? 0,
      windSpeed: (json['wind_speed_10m'] ?? 0).toDouble(),
      windDirection: (json['winddirection'] ?? 0).toDouble(),
      apparentTemperature: json['apparent_temperature'] != null
          ? (json['apparent_temperature']).toDouble()
          : null,
      visibility: visibility,
      humidity: (json['relative_humidity_2m'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'temperature_2m': temperature,
        'weathercode': weatherCode,
        'wind_speed_10m': windSpeed,
        'winddirection': windDirection,
        'apparent_temperature': apparentTemperature,
        'visibility': visibility,
        'relative_humidity_2m': humidity,
      };
}

class HourlyWeather {
  final String time;
  final double? temperature;
  final int? weatherCode;
  final double? apparentTemperature;
  final double? precipitation;
  final double? cloudCover;
  final double? windSpeed;
  final double? windDirection;
  final double? humidity;
  final double? visibility;

  HourlyWeather({
    required this.time,
    this.temperature,
    this.weatherCode,
    this.apparentTemperature,
    this.precipitation,
    this.cloudCover,
    this.windSpeed,
    this.windDirection,
    this.humidity,
    this.visibility,
  });

  Map<String, dynamic> toJson() => {
        'time': time,
        'temperature': temperature,
        'weatherCode': weatherCode,
        'apparentTemperature': apparentTemperature,
        'precipitation': precipitation,
        'cloudCover': cloudCover,
        'windSpeed': windSpeed,
        'windDirection': windDirection,
        'humidity': humidity,
        'visibility': visibility,
      };
}

class DailyWeather {
  final String date;
  final double? tempMax;
  final double? tempMin;
  final int? weatherCode;
  final double? precipitation;
  final double? windSpeedMax;
  final double? windDirection;

  DailyWeather({
    required this.date,
    this.tempMax,
    this.tempMin,
    this.weatherCode,
    this.precipitation,
    this.windSpeedMax,
    this.windDirection,
  });

  Map<String, dynamic> toJson() => {
        'date': date,
        'tempMax': tempMax,
        'tempMin': tempMin,
        'weatherCode': weatherCode,
        'precipitation': precipitation,
        'windSpeedMax': windSpeedMax,
        'windDirection': windDirection,
      };
}
