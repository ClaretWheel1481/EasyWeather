import 'package:easyweather/utils/secure.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:easyweather/pages/home/view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:date_format/date_format.dart';

var api = "http://easyweather.claret.space:37878";

class WeatherService {
  DateTime _lastFetchTime = DateTime.fromMillisecondsSinceEpoch(0);
  Map<String, dynamic> _cachedWeatherData = {};

  void clearCache() {
    _cachedWeatherData = {};
    _lastFetchTime = DateTime.fromMillisecondsSinceEpoch(0);
  }

  Future<Map<String, dynamic>> getLocationWeather() async {
    if (_cachedWeatherData.isNotEmpty &&
        DateTime.now().difference(_lastFetchTime).inMinutes < 30) {
      return _cachedWeatherData;
    }

    String? token = await getToken();
    var url = Uri.parse('$api/v1/data/baseCityInfo/${wCtr.locality}');
    var response = await http.get(url, headers: {
      'Authorization': token ?? '',
    });
    final Map<String, dynamic> jsonData = json.decode(response.body);

    _cachedWeatherData = jsonData;
    _lastFetchTime = DateTime.now();

    wCtr.cityname.value = jsonData['districts'][0]['name'];
    wCtr.cityid = jsonData['districts'][0]['adcode'];
    await Future.wait(
        [getNowWeather(), getNowWeatherAll(), getQweatherCityId()]);
    await Future.wait([getCityAir(), getCityIndices()]);

    return _cachedWeatherData;
  }

  Future getNowWeather() async {
    String? token = await getToken();
    var url = Uri.parse('$api/v1/data/baseWeatherInfo/${wCtr.cityid}');
    var response = await http.get(url, headers: {
      'Authorization': token ?? '',
    });
    Map<String, dynamic> infos = json.decode(response.body);

    var liveData = infos['lives'][0];
    wCtr.tempera.value = liveData['temperature'];
    wCtr.weather.value = liveData['weather'];
    wCtr.winddirection.value = liveData['winddirection'];
    wCtr.windpower.value = liveData['windpower'];
    wCtr.humidity.value = liveData['humidity'];
  }

  Future getNowWeatherAll() async {
    String? token = await getToken();
    var url = Uri.parse('$api/v1/data/allWeatherInfo/${wCtr.cityid}');
    var response = await http.get(url, headers: {
      'Authorization': token ?? '',
    });
    Map<String, dynamic> infos = json.decode(response.body);

    wCtr.hightemp.value = infos['forecasts'][0]['casts'][0]['daytemp'];
    wCtr.lowtemp.value = infos['forecasts'][0]['casts'][0]['nighttemp'];

    for (int i = 1; i <= 3; i++) {
      var cast = infos['forecasts'][0]['casts'][i];
      var date = DateTime.parse(cast['date']);
      var formattedDate = formatDate(date, [mm, '/', dd]);

      switch (i) {
        case 1:
          wCtr.day1weather.value = cast['dayweather'];
          wCtr.day1HighTemp.value = cast['daytemp'];
          wCtr.day1LowTemp.value = cast['nighttemp'];
          wCtr.day1date.value = formattedDate;
          wCtr.day1Week.value = cast['week'];
          break;
        case 2:
          wCtr.day2weather.value = cast['dayweather'];
          wCtr.day2HighTemp.value = cast['daytemp'];
          wCtr.day2LowTemp.value = cast['nighttemp'];
          wCtr.day2date.value = formattedDate;
          wCtr.day2Week.value = cast['week'];
          break;
        case 3:
          wCtr.day3weather.value = cast['dayweather'];
          wCtr.day3HighTemp.value = cast['daytemp'];
          wCtr.day3LowTemp.value = cast['nighttemp'];
          wCtr.day3date.value = formattedDate;
          wCtr.day3Week.value = cast['week'];
          break;
      }
    }
  }

  Future getQweatherCityId() async {
    String? token = await getToken();
    var url = Uri.parse('$api/v1/data/CityId/${wCtr.cityid}');
    var response = await http.get(url, headers: {
      'Authorization': token ?? '',
    });
    Map<String, dynamic> infos = jsonDecode(response.body);
    wCtr.qWeatherId.value = infos['location'][0]['id'];
    url = Uri.parse('$api/v1/data/CityWarning/${wCtr.qWeatherId}');
    response = await http.get(url, headers: {
      'Authorization': token ?? '',
    });
    Map<String, dynamic> temper4 = jsonDecode(response.body);
    wCtr.weatherWarning.value = temper4['warning']?.isNotEmpty ?? false
        ? temper4['warning'][0]['text']
        : "无";
  }

  Future getCityIndices() async {
    String? token = await getToken();
    var url = Uri.parse('$api/v1/data/CityIndices/${wCtr.qWeatherId}');
    var response = await http.get(url, headers: {
      'Authorization': token ?? '',
    });
    Map<String, dynamic> infos = jsonDecode(response.body);
    wCtr.carWashIndice.value = infos['daily'][0]['category'];
    wCtr.sportIndice.value = infos['daily'][1]['category'];
  }

  Future getCityAir() async {
    String? token = await getToken();
    var url = Uri.parse('$api/v1/data/CityAir/${wCtr.qWeatherId}');
    var response = await http.get(url, headers: {
      'Authorization': token ?? '',
    });
    Map<String, dynamic> infos = jsonDecode(response.body);
    wCtr.airQuality.value = infos['now']['category'];
  }
}

void requestLocationPermission(BuildContext context) async {
  var status = await Permission.location.request();
  if (status.isGranted) {
    try {
      showNotification("通知", "正在获取位置中，请稍后。");
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
          forceAndroidLocationManager: true,
          timeLimit: const Duration(seconds: 5));
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      wCtr.locality.value = place.locality!;
      await WeatherService().getLocationWeather();
      addCityToList(cityList, wCtr.locality.value);
      saveData();
    } catch (e) {
      if (e is LocationServiceDisabledException) {
        showNotification("错误", "失败，没有启用设备的定位服务。");
      } else {
        showNotification("错误", "位置获取失败，请尝试手动搜索城市。");
      }
    }
  } else {
    showNotification("错误", "您拒绝了EasyWeather的定位权限！");
  }
}

void saveData() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList('list', cityList);
  await prefs.setString('cityname', wCtr.locality.value);
}

Future<List<String>> getList() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('list') ?? [];
}

Future<String> getCityName() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('cityname') ?? "";
}

void addCityToList(List<String> list, String element) {
  if (!list.contains(element)) {
    list.add(element);
    showNotification("通知", "已将${wCtr.locality}添加到城市列表中。");
  } else {
    showNotification("通知", "$element已在列表内，若删除请长按城市。");
  }
}

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void showNotification(String title, String content) {
  final snackBar = SnackBar(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(content),
      ],
    ),
    duration: const Duration(milliseconds: 1800),
    behavior: SnackBarBehavior.fixed,
  );

  scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
}
