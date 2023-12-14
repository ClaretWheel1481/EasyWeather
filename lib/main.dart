import 'package:easyweather/function.dart';
import 'package:flutter/material.dart';
import 'package:easyweather/home.dart';

void main() async{
  // EasyWeather！启动！
  runApp(const MyApp());

  // 启动后数据读取处理
  Future<List<String>> futureCityList = getList();
  cityList = await futureCityList;

  Future<String> futureCityName = getCityName();
  controller.locality.value = await futureCityName;
  
  // 优化第一次启动与正常启动
  if(controller.locality.value != ''){
    getLocationWeather();
  }else{
    controller.cityname.value = "北京市";
    controller.cityid = '110000';
  }
}
