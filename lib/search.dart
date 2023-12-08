import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easyweather/home.dart';
import 'package:easyweather/function.dart';

class Search extends StatefulWidget{
  const Search({super.key});
  @override
  SearchState createState() => SearchState();
}

class SearchState extends State<Search>{

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
              getNowWeather();
              getNowWeatherAll();
              addCityToList(cityList, controller.cityname.value);
              saveData();
            });
        },
      )
    );
  }
}