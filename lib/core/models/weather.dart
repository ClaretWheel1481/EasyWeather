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
          weatherCode: json['hourly']['weather_code']?[i],
          precipitation: (json['hourly']['precipitation']?[i])?.toDouble(),
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
          weatherCode: json['daily']['weather_code']?[i],
          uvIndexMax: (json['daily']['uv_index_max']?[i])?.toDouble(),
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
          'weather_code': hourly.map((e) => e.weatherCode).toList(),
          'precipitation': hourly.map((e) => e.precipitation).toList(),
          'visibility': hourly.map((e) => e.visibility).toList(),
        },
        'daily': {
          'time': daily.map((e) => e.date).toList(),
          'temperature_2m_max': daily.map((e) => e.tempMax).toList(),
          'temperature_2m_min': daily.map((e) => e.tempMin).toList(),
          'weather_code': daily.map((e) => e.weatherCode).toList(),
          'uv_index_max': daily.map((e) => e.uvIndexMax).toList(),
        },
      };
}

class CurrentWeather {
  final double temperature;
  final int weatherCode;
  final double windSpeed;
  final double? windDirection;
  final double? apparentTemperature;
  final double? humidity;
  final double? surfacePressure;

  CurrentWeather({
    required this.temperature,
    required this.weatherCode,
    required this.windSpeed,
    required this.windDirection,
    this.apparentTemperature,
    this.humidity,
    this.surfacePressure,
  });

  factory CurrentWeather.fromJson(
      Map<String, dynamic> json, double? visibility) {
    return CurrentWeather(
      temperature: (json['temperature_2m'] ?? 0).toDouble(),
      weatherCode: json['weather_code'] ?? 0,
      windSpeed: (json['wind_speed_10m'] ?? 0).toDouble(),
      windDirection: (json['winddirection_10m'] ?? 0).toDouble(),
      apparentTemperature: json['apparent_temperature'] != null
          ? (json['apparent_temperature']).toDouble()
          : null,
      humidity: (json['relative_humidity_2m'] ?? 0).toDouble(),
      surfacePressure: (json['surface_pressure'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'temperature_2m': temperature,
        'weather_code': weatherCode,
        'wind_speed_10m': windSpeed,
        'winddirection_10m': windDirection,
        'apparent_temperature': apparentTemperature,
        'relative_humidity_2m': humidity,
        'surface_pressure': surfacePressure,
      };
}

class HourlyWeather {
  final String time;
  final double? temperature;
  final int? weatherCode;
  final double? apparentTemperature;
  final double? precipitation;
  final double? visibility;

  HourlyWeather({
    required this.time,
    this.temperature,
    this.weatherCode,
    this.apparentTemperature,
    this.precipitation,
    this.visibility,
  });

  Map<String, dynamic> toJson() => {
        'time': time,
        'temperature_2m': temperature,
        'weather_code': weatherCode,
        'apparentTemperature': apparentTemperature,
        'precipitation': precipitation,
        'visibility': visibility,
      };
}

class DailyWeather {
  final String date;
  final double? tempMax;
  final double? tempMin;
  final int? weatherCode;
  final double? uvIndexMax;
  DailyWeather({
    required this.date,
    this.tempMax,
    this.tempMin,
    this.weatherCode,
    this.uvIndexMax,
  });

  Map<String, dynamic> toJson() => {
        'date': date,
        'tempMax': tempMax,
        'tempMin': tempMin,
        'weatherCode': weatherCode,
        'uv_index_max': uvIndexMax,
      };
}
