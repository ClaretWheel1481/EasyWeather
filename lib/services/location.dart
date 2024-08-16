import 'package:easyweather/pages/home/view.dart';
import 'package:easyweather/services/notify.dart';
import 'package:easyweather/services/weather.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

void requestLocationPermission(BuildContext context) async {
  var status = await Permission.location.request();
  if (status.isGranted) {
    _fetchLocationAndWeather();
  } else {
    showNotification("错误", "您拒绝了EasyWeather的定位权限！");
  }
}

Future<void> _fetchLocationAndWeather() async {
  try {
    showNotification("通知", "正在获取位置中，请稍后。");
    Position position = await _getCurrentPosition();
    Placemark place = await _getPlacemarkFromPosition(position);
    _updateWeatherData(place.locality!);
  } catch (e) {
    if (e is Exception) {
      _handleLocationError(e);
    } else {
      showNotification("错误", "未知错误，请稍后重试。");
    }
  }
}

Future<Position> _getCurrentPosition() async {
  return await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.best,
    forceAndroidLocationManager: true,
    timeLimit: const Duration(seconds: 5),
  );
}

Future<Placemark> _getPlacemarkFromPosition(Position position) async {
  List<Placemark> placemarks = await placemarkFromCoordinates(
    position.latitude,
    position.longitude,
  );
  return placemarks[0];
}

Future<void> _updateWeatherData(String locality) async {
  wCtr.locality.value = locality;
  await WeatherService().getLocationWeather();
  addCityToList(cityList, locality);
  saveData();
}

void _handleLocationError(Exception e) {
  if (e is LocationServiceDisabledException) {
    showNotification("错误", "失败，没有启用设备的定位服务。");
  } else {
    showNotification("错误", "位置获取失败，请尝试手动搜索城市。");
  }
}
