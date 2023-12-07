import 'package:easyweather/function.dart';
import 'package:flutter/material.dart';
import 'package:easyweather/home.dart';

void main() async{
  runApp(const MyApp());
  // 启动后数据读取处理。
  Future<List<String>> futureCityList = getList();
  cityList = await futureCityList;

  Future<String> futureCityName = getCityName();
  controller.locality.value = await futureCityName;

  getLocationWeather();
}
