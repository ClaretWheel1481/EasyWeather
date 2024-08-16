import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easyweather/pages/home/view.dart';
import 'package:easyweather/services/weather.dart';
import 'package:easyweather/modules/classes.dart';

class Search extends StatefulWidget {
  const Search({super.key});
  @override
  SearchState createState() => SearchState();
}

class SearchState extends State<Search> {
  final WeatherService weatherService = WeatherService();
  // 防抖节流，暂缓0.5s
  final debouncer = Debouncer(milliseconds: 500);
  bool isFetchingWeather = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
            autofocus: true,
            decoration: const InputDecoration(hintText: '输入城市'),
            textInputAction: TextInputAction.search,
            onChanged: (text) {
              debouncer.run(() {
                wCtr.query.value = text;
                cityQueryController.getData(wCtr.query.value);
              });
            }),
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
                if (!isFetchingWeather) {
                  isFetchingWeather = true;
                  wCtr.cityname.value = city.name;
                  wCtr.cityid = city.adcode;
                  wCtr.locality.value = city.name;
                  weatherService.getLocationWeather().then((_) {
                    isFetchingWeather = false;
                  });
                  Get.back();
                  addCityToList(cityList, wCtr.cityname.value);
                  saveData();
                }
              },
            );
          },
        );
      }),
    );
  }
}
