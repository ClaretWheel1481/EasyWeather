import 'package:easyweather/services/weather.dart';
import 'package:easyweather/services/auth.dart';
import 'package:get/get.dart';
import 'package:easyweather/modules/classes.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

//城市搜索页Controller
class CityController extends GetxController {
  final cityQueryList = <CityInfo>[].obs;
  List<CityInfo> get cityList2 => cityQueryList.toList();

  Future<void> getData(String query) async {
    String? token = await getToken();
    var url = Uri.parse('$api/v1/data/baseCityInfo/$query');
    var response = await http.get(url, headers: {
      'Authorization': token ?? '',
    });
    final data = jsonDecode(response.body);
    final districts = data['districts'] as List;
    cityQueryList.assignAll(
        districts.map((district) => CityInfo.fromJson(district)).toList());
  }
}

//天气变量Controller
class WeatherController extends GetxController {
  // 当前天气
  var tempera = ''.obs; // 当前温度
  var weather = ''.obs; // 天气情况
  var cityname = ''.obs; // 选中的市或区、县名称,用于显示
  var query = "北京".obs; // 用于搜索
  var hightemp = ''.obs; // 今日最高温度
  var lowtemp = ''.obs; // 今日最低温度
  var humidity = ''.obs; // 湿度
  var windpower = ''.obs; // 风力
  var winddirection = ''.obs; // 风向
  var locality = ''.obs; // 定位所在市、区、及启动保存的城市名
  var cityid = '0'; // 市、区ID

  // 未来几天天气
  var futureWeather = List.generate(3, (index) => WeatherDay()).obs;

  // 天气预警
  var weatherWarning = ''.obs; // 天气预警
  var qWeatherId = '0'.obs; // 和风天气城市id

  // 其他指数
  var airQuality = ''.obs; // 空气质量
  var carWashIndice = ''.obs; // 洗车指数
  var sportIndice = ''.obs; // 运动指数
}

class WeatherDay {
  var weather = ''.obs; // 天气情况
  var week = ''.obs; // 日期（星期）
  var lowTemp = ''.obs; // 最低温度
  var highTemp = ''.obs; // 最高温度
  var date = ''.obs; // 日期
}
