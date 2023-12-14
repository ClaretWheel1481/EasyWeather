import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:easyweather/home.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:date_format/date_format.dart';

void getData() async {    //解析查询城市信息
    var url = Uri.parse('http://43.138.219.71/v1/data/baseCityInfo/${controller.query}');
    var response = await http.get(url);
    final Map<String,dynamic>jsonData = json.decode(response.body);
    controller.cityname.value = jsonData['districts'][0]['name'];
    controller.cityid= jsonData['districts'][0]['adcode'];
}

void getNowWeather() async{    //获取当前天气
  var url = Uri.parse('http://43.138.219.71/v1/data/baseWeatherInfo/${controller.cityid}');
  var response = await http.get(url);
  Map<String,dynamic> temper = json.decode(response.body);
  controller.tempera.value = temper['lives'][0]['temperature'];
  controller.weather.value = temper['lives'][0]['weather'];
  controller.winddirection.value = temper['lives'][0]['winddirection'];
  controller.windpower.value = temper['lives'][0]['windpower'];
  controller.humidity.value = temper['lives'][0]['humidity'];
}

void getNowWeatherAll() async{    //获取所有天气信息
  var url = Uri.parse('http://43.138.219.71/v1/data/allWeatherInfo/${controller.cityid}');
  var response = await http.get(url);
  Map<String,dynamic> temper2 = json.decode(response.body);
  controller.hightemp.value = temper2['forecasts'][0]['casts'][0]['daytemp'];
  controller.lowtemp.value = temper2['forecasts'][0]['casts'][0]['nighttemp'];

  controller.day1weather.value = temper2['forecasts'][0]['casts'][1]['dayweather'];
  controller.day1hightemp.value = temper2['forecasts'][0]['casts'][1]['daytemp'];
  controller.day1lowtemp.value = temper2['forecasts'][0]['casts'][1]['nighttemp'];
  controller.day1date.value =formatDate(DateTime.parse(temper2['forecasts'][0]['casts'][1]['date']), [mm,'-',dd]);

  controller.day2weather.value = temper2['forecasts'][0]['casts'][2]['dayweather'];
  controller.day2hightemp.value = temper2['forecasts'][0]['casts'][2]['daytemp'];
  controller.day2lowtemp.value = temper2['forecasts'][0]['casts'][2]['nighttemp'];
  controller.day2date.value =formatDate(DateTime.parse(temper2['forecasts'][0]['casts'][2]['date']), [mm,'-',dd]);

  controller.day3weather.value = temper2['forecasts'][0]['casts'][3]['dayweather'];
  controller.day3hightemp.value = temper2['forecasts'][0]['casts'][3]['daytemp'];
  controller.day3lowtemp.value = temper2['forecasts'][0]['casts'][3]['nighttemp'];
  controller.day3date.value =formatDate(DateTime.parse(temper2['forecasts'][0]['casts'][3]['date']), [mm,'-',dd]);

  controller.day1week.value = temper2['forecasts'][0]['casts'][1]['week'];
  controller.day2week.value = temper2['forecasts'][0]['casts'][2]['week'];
  controller.day3week.value = temper2['forecasts'][0]['casts'][3]['week'];
}

void getLocationWeather() async {   //根据定位或保存的城市信息获取天气情况
  var url = Uri.parse('http://43.138.219.71/v1/data/baseCityInfo/${controller.locality}');
  var response = await http.get(url);
  final Map<String,dynamic>jsonData = json.decode(response.body);
  controller.cityname.value = jsonData['districts'][0]['name'];
  controller.cityid = jsonData['districts'][0]['adcode'];
  getNowWeather();
  getNowWeatherAll();
}

void requestLocationPermission() async {    //启用定位权限并检查
  var status = await Permission.location.request();
  if (status.isGranted) {
    try {     //获取经纬度转换为城市
      showSnackbar("通知","获取您的位置中，请稍后。");
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      controller.locality.value = place.locality!;
      getLocationWeather();
      addCityToList(cityList, controller.locality.value);
      saveData();
    } catch (e) {
      if (e is LocationServiceDisabledException) {
        showSnackbar("错误", "您没有启用设备的定位服务。");
      }else{
        showSnackbar("错误", "位置获取失败。");
      }
    }
  } else if (status.isDenied) {
    showSnackbar("错误", "您拒绝了EasyWeather的定位权限！");
  } else if (status.isPermanentlyDenied) {
    showSnackbar("错误", "您拒绝了EasyWeather的定位权限！");
  }
}

//数据持久化保存
void saveData() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList('list', cityList);
  await prefs.setString('cityname', controller.locality.value);
}

//TODO: 深色模式数据持久化
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
void addCityToList(List<String> list, String element) {
  if (!list.contains(element)) {
    list.add(element);
  } else{
    showSnackbar("通知", "您已经添加了$element在城市列表里了，若删除请长按该城市。");
  }
}

//减少工作量、提升可读性的Snackbar
void showSnackbar(String title,String content){
  Get.snackbar(title, content,duration: const Duration(milliseconds: 2200));
}