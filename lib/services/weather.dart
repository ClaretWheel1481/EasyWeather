import 'package:easyweather/constants/app_constants.dart';
import 'package:easyweather/modules/classes.dart';
import 'package:easyweather/pages/home/view.dart';
import 'package:easyweather/services/notify.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:date_format/date_format.dart';

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

    var url = Uri.parse(
        '${AppConstants.gaoDeAPI}/config/district?keywords=${wCtr.locality}&subdistrict=0&key=${AppConstants.gaoDeAPIKey}&extensions=base');
    var response = await http.get(url);
    final Map<String, dynamic> jsonData = json.decode(response.body);

    _cachedWeatherData = jsonData;
    _lastFetchTime = DateTime.now();

    wCtr.cityname.value = jsonData['districts'][0]['name'];
    wCtr.cityid = jsonData['districts'][0]['adcode'];
    await Future.wait([
      getNowWeather(),
      getNowWeatherAll(),
      getQweatherCityId(),
    ]);
    await Future.wait([getCityIndices(), getCityAir()]);

    return _cachedWeatherData;
  }

  // 获取当前天气
  Future getNowWeather() async {
    var url = Uri.parse(
        '${AppConstants.gaoDeAPI}/weather/weatherInfo?city=${wCtr.cityid}&key=${AppConstants.gaoDeAPIKey}&extensions=base');
    var response = await http.get(url);
    Map<String, dynamic> infos = json.decode(response.body);

    WeatherLive liveData = WeatherLive.fromJson(infos['lives'][0]);

    wCtr.tempera.value = liveData.temperature;
    wCtr.weather.value = liveData.weather;
    wCtr.winddirection.value = liveData.windDirection;
    wCtr.windpower.value = liveData.windPower;
    wCtr.humidity.value = liveData.humidity;
  }

  // 获取当前天气所有数据
  Future getNowWeatherAll() async {
    var url = Uri.parse(
        '${AppConstants.gaoDeAPI}/weather/weatherInfo?city=${wCtr.cityid}&key=${AppConstants.gaoDeAPIKey}&extensions=all');
    var response = await http.get(url);
    Map<String, dynamic> infos = json.decode(response.body);

    wCtr.hightemp.value = infos['forecasts'][0]['casts'][0]['daytemp'];
    wCtr.lowtemp.value = infos['forecasts'][0]['casts'][0]['nighttemp'];

    for (int i = 0; i < 3; i++) {
      var castJson = infos['forecasts'][0]['casts'][i];
      WeatherCast cast = WeatherCast.fromJson(castJson);
      var date = DateTime.parse(cast.date);
      var formattedDate = formatDate(date, [mm, '/', dd]);

      var weatherDay = wCtr.futureWeather[i];
      weatherDay.weather.value = cast.dayWeather;
      weatherDay.highTemp.value = cast.dayTemp;
      weatherDay.lowTemp.value = cast.nightTemp;
      weatherDay.date.value = formattedDate;
      weatherDay.week.value = cast.week.toString();
    }
  }

  Future getQweatherCityId() async {
    var url = Uri.parse(
        '${AppConstants.qWeatherAPI}/city/lookup?location=${wCtr.cityid}&key=${AppConstants.qWeatherAPIKey}');
    var response = await http.get(url);
    Map<String, dynamic> infos = jsonDecode(response.body);
    wCtr.qWeatherId.value = infos['location'][0]['id'];
    url = Uri.parse(
        '${AppConstants.qWeatherAPI_Dev}/warning/now?location=${wCtr.qWeatherId}&lang=cn&key=${AppConstants.qWeatherAPIKey_Dev}');
    response = await http.get(url);
    Map<String, dynamic> infos_1 = jsonDecode(response.body);
    wCtr.weatherWarning.value = infos_1['warning']?.isNotEmpty ?? false
        ? infos_1['warning'][0]['text']
        : "无";
  }

  Future getCityIndices() async {
    var url = Uri.parse(
        '${AppConstants.qWeatherAPI_Dev}/indices/1d?type=1,2&location=${wCtr.qWeatherId}&key=${AppConstants.qWeatherAPIKey_Dev}');
    var response = await http.get(url);
    Map<String, dynamic> infos = jsonDecode(response.body);
    wCtr.carWashIndice.value = infos['daily'][0]['category'];
    wCtr.sportIndice.value = infos['daily'][1]['category'];
  }

  Future getCityAir() async {
    var url = Uri.parse(
        '${AppConstants.qWeatherAPI_Dev}/air/now?location=${wCtr.qWeatherId}&key=${AppConstants.qWeatherAPIKey_Dev}');
    var response = await http.get(url);
    Map<String, dynamic> infos = jsonDecode(response.body);
    wCtr.airQuality.value = infos['now']['category'];
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

Future<String> loadThemeMode() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('themeMode') ?? 'system';
}

Future<void> saveThemeMode(String themeMode) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('themeMode', themeMode);
}
