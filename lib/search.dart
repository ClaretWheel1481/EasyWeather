import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easyweather/home.dart';
import 'package:easyweather/function.dart';
import 'package:easyweather/classes.dart';


class Search extends StatefulWidget{
  const Search({super.key});
  @override
  SearchState createState() => SearchState();
}

class SearchState extends State<Search>{
  // 防抖节流，暂缓0.2s
  final debouncer = Debouncer(milliseconds: 200);

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
              cityQueryController.getData(controller.query.value);
            });
          }
        ),
      ),
      body: Obx(() {
              final cityQueryList = cityQueryController.cityQueryList;
              return ListView.builder(
                itemCount: cityQueryList.length,
                itemBuilder: (context, index) {
                  final city = cityQueryList[index];
                  return ListTile(
                    leading: const Icon(Icons.location_on_outlined),
                    title: Text(city.name),
                    onTap: () {
                      controller.cityname.value = city.name;
                      controller.cityid = city.adcode;
                      Get.back();
                      getNowWeather();
                      getNowWeatherAll();
                      addCityToList(cityList, controller.cityname.value);
                      saveData();
                      showSnackbar("通知", "成功将${controller.cityname}添加到城市列表中。若需要设置为默认城市，请在城市列表中单击城市。");
                    },
                  );
                },
              );
            }),
    );
  }
}