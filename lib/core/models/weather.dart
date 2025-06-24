class WeatherData {
  final CurrentWeather? current;
  final List<HourlyWeather> hourly;
  final List<DailyWeather> daily;

  WeatherData({this.current, required this.hourly, required this.daily});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final current = json['current_weather'] != null
        ? CurrentWeather.fromJson(json['current_weather'])
        : null;
    final hourlyList = <HourlyWeather>[];
    if (json['hourly'] != null && json['hourly']['time'] != null) {
      final times = List<String>.from(json['hourly']['time']);
      for (int i = 0; i < times.length; i++) {
        hourlyList.add(HourlyWeather(
          time: times[i],
          temperature: (json['hourly']['temperature_2m']?[i])?.toDouble(),
          weatherCode: json['hourly']['weathercode']?[i],
          apparentTemperature:
              (json['hourly']['apparent_temperature']?[i])?.toDouble(),
          precipitation: (json['hourly']['precipitation']?[i])?.toDouble(),
          cloudCover: (json['hourly']['cloudcover']?[i])?.toDouble(),
          windSpeed: (json['hourly']['windspeed_10m']?[i])?.toDouble(),
          windDirection: (json['hourly']['winddirection_10m']?[i])?.toDouble(),
          humidity: (json['hourly']['relative_humidity_2m']?[i])?.toDouble(),
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
        'current_weather': current?.toJson(),
        'hourly': {
          'time': hourly.map((e) => e.time).toList(),
          'temperature_2m': hourly.map((e) => e.temperature).toList(),
          'weathercode': hourly.map((e) => e.weatherCode).toList(),
          'apparent_temperature':
              hourly.map((e) => e.apparentTemperature).toList(),
          'precipitation': hourly.map((e) => e.precipitation).toList(),
          'cloudcover': hourly.map((e) => e.cloudCover).toList(),
          'windspeed_10m': hourly.map((e) => e.windSpeed).toList(),
          'winddirection_10m': hourly.map((e) => e.windDirection).toList(),
          'relative_humidity_2m': hourly.map((e) => e.humidity).toList(),
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

  CurrentWeather({
    required this.temperature,
    required this.weatherCode,
    required this.windSpeed,
    this.windDirection,
    this.apparentTemperature,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      temperature: (json['temperature'] ?? 0).toDouble(),
      weatherCode: json['weathercode'] ?? 0,
      windSpeed: (json['windspeed'] ?? 0).toDouble(),
      windDirection: (json['winddirection'] ?? 0).toDouble(),
      apparentTemperature: json['apparent_temperature'] != null
          ? (json['apparent_temperature']).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'temperature': temperature,
        'weathercode': weatherCode,
        'windspeed': windSpeed,
        'winddirection': windDirection,
        'apparent_temperature': apparentTemperature,
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
