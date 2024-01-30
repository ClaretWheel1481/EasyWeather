import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easyweather/home.dart';
import 'package:easyweather/classes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//天气变量Controller
class WeatherController extends GetxController{
  var tempera = ''.obs; //当前温度
  var weather = ''.obs; //天气情况
  var cityname = ''.obs;  //选中的市或区、县名称,用于显示
  var query = "北京".obs; //用于搜索
  var hightemp = ''.obs; //今日最高温度
  var lowtemp = ''.obs;  //今日最低温度
  var humidity = ''.obs;  //湿度
  var windpower = ''.obs; //风力
  var winddirection = ''.obs; //风向
  var locality = ''.obs;  //定位所在市、区、及启动保存的城市名
  var cityid = '0'; //市、区ID

  var day1weather = ''.obs; //明日天气
  var day2weather = ''.obs; //后日天气
  var day3weather = ''.obs; //大后日天气

  var day1week = ''.obs;  //明日日期（星期）
  var day2week = ''.obs;  //后日日期（星期）
  var day3week = ''.obs;  //大后日日期（星期）

  var day1lowtemp = ''.obs; //明日最低温度
  var day1hightemp = ''.obs;  //明日最高温度

  var day2lowtemp = ''.obs; //后日最低温度
  var day2hightemp = ''.obs;  //后日最高温度

  var day3lowtemp = ''.obs; //大后日最低温度
  var day3hightemp = ''.obs;  //大后日最高温度
  
  var day1date = ''.obs;  //明日日期
  var day2date = ''.obs;  //后日日期
  var day3date = ''.obs;  //大后日日期

  var weatherWarning = ''.obs;  //天气预警
  var qWeatherId = '0'.obs;   //彩云天气城市id
}

//Appbar城市名与应用标题切换Controller
class AnimateController extends GetxController {

  var appBarTitle = 'EasyWeather'.obs;

  ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(() {
      if(scrollController.offset < 30){
        appBarTitle.value = 'EasyWeather';
      }else if (scrollController.offset < 60) {
        appBarTitle.value = '';
      }else if (scrollController.offset < 200) {
        appBarTitle.value = controller.cityname.value;
      }
    });
  }

  void scrollToTop() {
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}

//城市搜索页Controller
class CityController extends GetxController {
  final cityQueryList = <CityInfo>[].obs;
  List<CityInfo> get cityList2 => cityQueryList.toList();
  
  Future<void> getData(String query) async {
    final response = await http.get(Uri.parse('http://easyweather.claret.space:37878/v1/data/baseCityInfo/$query'));
    final data = jsonDecode(response.body);
    final districts = data['districts'] as List;
    cityQueryList.assignAll(districts.map((district) => CityInfo.fromJson(district)).toList());
  }
}