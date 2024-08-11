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

Future getNowWeather() async {
  // 获取当前天气
  var url = Uri.parse(
      'http://easyweather.claret.space:37878/v1/data/baseWeatherInfo/${wCtr.cityid}');
  var response = await http.get(url);
  Map<String, dynamic> infos = json.decode(response.body);

  // 更新天气信息
  var liveData = infos['lives'][0];
  wCtr.tempera.value = liveData['temperature'];
  wCtr.weather.value = liveData['weather'];
  wCtr.winddirection.value = liveData['winddirection'];
  wCtr.windpower.value = liveData['windpower'];
  wCtr.humidity.value = liveData['humidity'];
}

Future getNowWeatherAll() async {
  // 获取所有天气信息
  var url = Uri.parse(
      'http://easyweather.claret.space:37878/v1/data/allWeatherInfo/${wCtr.cityid}');
  var response = await http.get(url);
  Map<String, dynamic> infos = json.decode(response.body);

  // 更新今日温度
  wCtr.hightemp.value = infos['forecasts'][0]['casts'][0]['daytemp'];
  wCtr.lowtemp.value = infos['forecasts'][0]['casts'][0]['nighttemp'];

  // 更新未来三天天气信息
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
  //通过高德开放平台的adcode转换为彩云平台的cityid获取当前城市天气预警、空气质量、天气指数
  var url = Uri.parse(
      'http://easyweather.claret.space:37878/v1/data/getCityId/${wCtr.cityid}');
  var response = await http.get(url);
  Map<String, dynamic> infos = jsonDecode(response.body);
  wCtr.qWeatherId.value = infos['location'][0]['id'];
  url = Uri.parse(
      'http://easyweather.claret.space:37878/v1/data/getCityWarning/${wCtr.qWeatherId}');
  response = await http.get(url);
  Map<String, dynamic> temper4 = jsonDecode(response.body);
  if (temper4['warning'] != null && temper4['warning'].isNotEmpty) {
    wCtr.weatherWarning.value = temper4['warning'][0]['text'];
  } else {
    wCtr.weatherWarning.value = "无";
  }
}

//天气指数
Future getCityIndices() async {
  var url = Uri.parse(
      'http://easyweather.claret.space:37878/v1/data/getCityIndices/${wCtr.qWeatherId}');
  var response = await http.get(url);
  Map<String, dynamic> infos = jsonDecode(response.body);
  wCtr.carWashIndice.value = infos['daily'][0]['category'];
  wCtr.sportIndice.value = infos['daily'][1]['category'];
}

//空气指数
Future getCityAir() async {
  var url = Uri.parse(
      'http://easyweather.claret.space:37878/v1/data/getCityAir/${wCtr.qWeatherId}');
  var response = await http.get(url);
  Map<String, dynamic> infos = jsonDecode(response.body);
  wCtr.airQuality.value = infos['now']['category'];
}

Future getLocationWeather() async {
  //根据定位或保存的城市信息获取天气情况
  var url = Uri.parse(
      'http://easyweather.claret.space:37878/v1/data/baseCityInfo/${wCtr.locality}');
  var response = await http.get(url);
  final Map<String, dynamic> jsonData = json.decode(response.body);
  wCtr.cityname.value = jsonData['districts'][0]['name'];
  wCtr.cityid = jsonData['districts'][0]['adcode'];
  await Future.wait([getNowWeather(), getNowWeatherAll(), getQweatherCityId()]);
  await Future.wait([getCityAir(), getCityIndices()]);
}

void requestLocationPermission(BuildContext context) async {
  //启用定位权限并检查
  var status = await Permission.location.request();
  if (status.isGranted) {
    try {
      //获取经纬度转换为城市
      showNotification("通知", "正在获取位置中，请稍后。");
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
          forceAndroidLocationManager: true,
          timeLimit: const Duration(seconds: 5));
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      wCtr.locality.value = place.locality!;
      await getLocationWeather();
      addCityToList(context, cityList, wCtr.locality.value);
      saveData();
    } catch (e) {
      if (e is LocationServiceDisabledException) {
        showNotification("错误", "失败，没有启用设备的定位服务。");
      } else {
        showNotification("错误", "位置获取失败，请尝试手动搜索城市。");
      }
    }
  } else if (status.isDenied) {
    showNotification("错误", "您拒绝了EasyWeather的定位权限！");
  } else if (status.isPermanentlyDenied) {
    showNotification("错误", "您拒绝了EasyWeather的定位权限！");
  }
}

//数据持久化保存
void saveData() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList('list', cityList);
  await prefs.setString('cityname', wCtr.locality.value);
}

//数据cityList、cityname读取
Future<List<String>> getList() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('list') ?? [];
}

Future<String> getCityName() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('cityname') ?? "";
}

//List数据查重添加
void addCityToList(BuildContext context, List<String> list, String element) {
  if (!list.contains(element)) {
    list.add(element);
    showNotification("通知", "已将${wCtr.locality}添加到城市列表中。");
  } else {
    showNotification("通知", "$element已在列表内，若删除请长按城市。");
  }
}

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

// 通知
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
