import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easyweather/home.dart';
import 'package:easyweather/function.dart';
import 'dart:async';

// 防抖类
class Debouncer {
  final int milliseconds;
  VoidCallback? action;
  Timer _timer = Timer(Duration.zero, () {});

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {  
    // ignore: unnecessary_null_comparison
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class Search extends StatefulWidget{
  const Search({super.key});
  @override
  SearchState createState() => SearchState();
}

class SearchState extends State<Search>{
  // 防抖节流，暂缓0.5s
  final debouncer = Debouncer(milliseconds: 500);

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
            debouncer.run(() {    // 节流
              controller.query.value = text;
              setState(() {
                getData();
              });
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
              getNowWeather();
              getNowWeatherAll();
              addCityToList(cityList, controller.cityname.value);
              saveData();
              showSnackbar("通知", "成功将${controller.cityname}添加到城市列表中。若需要设置为默认城市，请在城市列表中单击城市。");
            });
        },
      )
    );
  }
}