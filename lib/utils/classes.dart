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
    // ignore: unnecessary_null_comparison
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
