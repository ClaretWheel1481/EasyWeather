import 'package:easyweather/utils/function.dart';
import 'package:easyweather/utils/secure.dart';
import 'package:get/get.dart';
import 'package:easyweather/utils/classes.dart';

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
  var tempera = ''.obs; //当前温度
  var weather = ''.obs; //天气情况
  var cityname = ''.obs; //选中的市或区、县名称,用于显示
  var query = "北京".obs; //用于搜索
  var hightemp = ''.obs; //今日最高温度
  var lowtemp = ''.obs; //今日最低温度
  var humidity = ''.obs; //湿度
  var windpower = ''.obs; //风力
  var winddirection = ''.obs; //风向
  var locality = ''.obs; //定位所在市、区、及启动保存的城市名
  var cityid = '0'; //市、区ID

  var day1weather = ''.obs; //明日天气
  var day2weather = ''.obs; //后日天气
  var day3weather = ''.obs; //大后日天气

  var day1Week = ''.obs; //明日日期（星期）
  var day2Week = ''.obs; //后日日期（星期）
  var day3Week = ''.obs; //大后日日期（星期）

  var day1LowTemp = ''.obs; //明日最低温度
  var day1HighTemp = ''.obs; //明日最高温度

  var day2LowTemp = ''.obs; //后日最低温度
  var day2HighTemp = ''.obs; //后日最高温度

  var day3LowTemp = ''.obs; //大后日最低温度
  var day3HighTemp = ''.obs; //大后日最高温度

  var day1date = ''.obs; //明日日期
  var day2date = ''.obs; //后日日期
  var day3date = ''.obs; //大后日日期

  var weatherWarning = ''.obs; //天气预警
  var qWeatherId = '0'.obs; //和风天气城市id

  var airQuality = ''.obs; //空气质量
  var carWashIndice = ''.obs; //洗车指数
  var sportIndice = ''.obs; //运动指数
}
