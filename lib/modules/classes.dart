import 'package:flutter/material.dart';
import 'dart:async';

//城市Json格式化类
class CityInfo {
  final String name;
  final String adcode;

  CityInfo({required this.name, required this.adcode});

  factory CityInfo.fromJson(Map<String, dynamic> json) {
    return CityInfo(
      name: json['name'],
      adcode: json['adcode'],
    );
  }
}

// 防抖类
class Debouncer {
  final int milliseconds;
  VoidCallback? action;
  Timer _timer = Timer(Duration.zero, () {});

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    _timer.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

// 当前天气类
class WeatherLive {
  String adcode;
  String city;
  String humidity;
  double humidityFloat;
  String province;
  String reportTime;
  String temperature;
  double temperatureFloat;
  String weather;
  String windDirection;
  String windPower;

  WeatherLive({
    required this.adcode,
    required this.city,
    required this.humidity,
    required this.humidityFloat,
    required this.province,
    required this.reportTime,
    required this.temperature,
    required this.temperatureFloat,
    required this.weather,
    required this.windDirection,
    required this.windPower,
  });

  factory WeatherLive.fromJson(Map<String, dynamic> json) {
    return WeatherLive(
      adcode: json['adcode'],
      city: json['city'],
      humidity: json['humidity'],
      humidityFloat: double.parse(json['humidity_float']),
      province: json['province'],
      reportTime: json['reporttime'],
      temperature: json['temperature'],
      temperatureFloat: double.parse(json['temperature_float']),
      weather: json['weather'],
      windDirection: json['winddirection'],
      windPower: json['windpower'],
    );
  }
}

// 未来天气预报类
class WeatherCast {
  String date;
  String dayPower;
  String dayTemp;
  double dayTempFloat;
  String dayWeather;
  String dayWind;
  String nightPower;
  String nightTemp;
  double nightTempFloat;
  String nightWeather;
  String nightWind;
  String week;

  WeatherCast({
    required this.date,
    required this.dayPower,
    required this.dayTemp,
    required this.dayTempFloat,
    required this.dayWeather,
    required this.dayWind,
    required this.nightPower,
    required this.nightTemp,
    required this.nightTempFloat,
    required this.nightWeather,
    required this.nightWind,
    required this.week,
  });

  factory WeatherCast.fromJson(Map<String, dynamic> json) {
    return WeatherCast(
      date: json['date'],
      dayPower: json['daypower'],
      dayTemp: json['daytemp'],
      dayTempFloat: double.parse(json['daytemp_float']),
      dayWeather: json['dayweather'],
      dayWind: json['daywind'],
      nightPower: json['nightpower'],
      nightTemp: json['nighttemp'],
      nightTempFloat: double.parse(json['nighttemp_float']),
      nightWeather: json['nightweather'],
      nightWind: json['nightwind'],
      week: json['week'],
    );
  }
}
