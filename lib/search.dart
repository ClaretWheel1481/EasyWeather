import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:easyweather/Home.dart';

var cityid = '0';

final Mycontroller controller = Get.put(Mycontroller());

void getData() async {    //解析Json
    var url = Uri.parse('https://restapi.amap.com/v3/config/district?keywords=${controller.query}&subdistrict=0&key=ed5b8f909739b3b48b40b2f220993fd9&extensions=base');
    var response = await http.get(url);
    final Map<String,dynamic>jsonData = json.decode(response.body);
    controller.cityname.value = jsonData['districts'][0]['name'];
    cityid= jsonData['districts'][0]['adcode'];
}

void loadnow() async{    //获取当前位置与现在天气
  var url = Uri.parse('https://restapi.amap.com/v3/weather/weatherInfo?city=$cityid&key=ed5b8f909739b3b48b40b2f220993fd9&extensions=base');
  var response = await http.get(url);
  Map<String,dynamic> temper = json.decode(response.body);
  controller.tempera.value = temper['lives'][0]['temperature'];
  controller.weather.value = temper['lives'][0]['weather'];
  controller.winddirection.value = temper['lives'][0]['winddirection'];
  controller.windpower.value = temper['lives'][0]['windpower'];
  controller.humidity.value = temper['lives'][0]['humidity'];
}

void loadall() async{    //获取所有天气信息
  var url = Uri.parse('https://restapi.amap.com/v3/weather/weatherInfo?city=$cityid&key=ed5b8f909739b3b48b40b2f220993fd9&extensions=all');
  var response = await http.get(url);
  Map<String,dynamic> temper = json.decode(response.body);
  controller.hightemp1.value = temper['forecasts'][0]['casts'][0]['daytemp'];
  controller.lowtemp1.value = temper['forecasts'][0]['casts'][0]['nighttemp'].toString();
}

class Search extends StatefulWidget{
  const Search({super.key});
  @override
  SearchState createState() => SearchState();
}

class SearchState extends State<Search>{

  @override
  void initState(){
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
        leading: IconButton(
          icon:const Icon(Icons.arrow_back),
          onPressed: (){
            Get.back();
          },
        ),
        title: TextField(
          autofocus: true,
          decoration: const InputDecoration(hintText: '输入城市'),
          textInputAction: TextInputAction.search,
          onChanged: (text){
              controller.query.value = text;
              setState(() {
                getData();
              });
            }
        ),
      ),
      body: ListTile(
        leading: const Icon(Icons.location_on),
        title: Obx(()=>Text(controller.cityname.value)),
        onTap: () async{
            Get.back();
            setState(() {
              loadnow();
              loadall();
            });
        },
      )
    );
  }
}