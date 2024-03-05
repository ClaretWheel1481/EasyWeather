import 'package:easyweather/pages/search/search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easyweather/function.dart';
import 'package:easyweather/controller.dart';
import 'package:easyweather/pages/home/widgets.dart';
import 'package:easyweather/items.dart';
import 'package:expandable_text/expandable_text.dart';

List<String> cityList = []; //数据持久化天气列表

//伟大的controller!初始化！
WeatherController controller = Get.put(WeatherController());
AnimateController scrollAppbarController = Get.put(AnimateController());
CityController cityQueryController = Get.put(CityController());

class MyApp extends StatelessWidget {

  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        fontFamily: "HMOS"
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: "HMOS"
      ),
      themeMode: ThemeMode.system,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.locality.value == '' ? //三目运算判断是否已经获取了城市
      Scaffold(
        appBar: AppBar(
          title: const Text("EasyWeather"),
          actions: [
            IconButton(
              onPressed: () async {
                requestLocationPermission();
              },
              icon: const Icon(Icons.location_on_outlined)
            ),
            IconButton(
              onPressed: (){
                Get.to(()=>const Search(),transition: Transition.cupertino);
              },
              icon: const Icon(Icons.search)
            ),
          ],
        ),
        body:const Center(
          child: Text('点击右上角"搜索"，进行搜索城市。\n或点击右上角“定位”，获取您所在的城市。'),
        ),
      )
        :
    Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title:AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          transitionBuilder: (child, animation) => SizeTransition(
              sizeFactor: animation,
              child: child,
          ),
          child: Text(scrollAppbarController.appBarTitle.value,
          key: ValueKey(scrollAppbarController.appBarTitle.value),)
        ),
        actions: <Widget>[
          PopupMenuButton(
            icon: const Icon(Icons.location_city_rounded),
            itemBuilder: (context) => cityList.map((e) => PopupMenuItem(value: e,
                child: GestureDetector(
                  onLongPress: () {
                    setState(() {
                      cityList.remove(e); // 删除长按的元素
                      Get.back();
                      showSnackbar("通知", "已删除$e！");
                      saveData();
                    });
                  },
                  child: Row(children: [const Icon(Icons.location_on), Text(e)]),
                ))).toList(),
            onSelected: (value){
              controller.locality.value = value;
              getLocationWeather();
              Get.back();
              scrollAppbarController.scrollToTop();
              showSnackbar("通知", "当前默认城市为$value！");
              saveData();
            },
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))
            ),
          ),
          IconButton(
            onPressed: () async {
              requestLocationPermission();
            },
            icon: const Icon(Icons.location_on_outlined)
          ),
          IconButton(
            onPressed: (){
              Get.to(()=>const Search(),transition: Transition.cupertino);
            },
            icon: const Icon(Icons.search)
          ),
        ],
      ),
      body: getWeatherBody(),
      )
    );
  }

  Widget getWeatherBody(){ //获取天气后改变的主页面
    //天气背景变化+过渡动画
    return Hero(
      tag: 'weather',
      child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 900),
              child: Container(
                key: ValueKey(weatherBackground[controller.weather.value]),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(weatherBackground[controller.weather.value] ?? "assets/images/sunny.jpg"),
                    fit: BoxFit.cover,
                    opacity: Get.isDarkMode ? 0.5 : 0.7
                  )
                ),
                child: RefreshIndicator(  //下拉刷新
                  onRefresh:() async{
                    await getLocationWeather();
                  },
                  displacement: 50.0,
                  child: ListView(
                    controller: scrollAppbarController.scrollController,
                    children: <Widget>[
                      Center(
                          child:Obx(()=>
                              Text.rich(TextSpan(children: <InlineSpan>[
                                const WidgetSpan(child: SizedBox(width: 18,height: 30,child: Icon(Icons.location_on),)),
                                TextSpan(text:" ${controller.cityname}",style: const TextStyle(fontSize: 28)),
                              ])),
                          )
                      ),
                      Center(
                          child:Obx(()=>
                              Text.rich(TextSpan(children: <InlineSpan>[
                                WidgetSpan(child: SizedBox(child: Icon(weatherIcons[controller.weather.value]))),
                                TextSpan(text:" ${controller.weather}",style: const TextStyle(fontSize: 20)),
                              ])),
                          )
                      ),
                      const SizedBox(height: 140),
                      Center(
                          child:Obx(()=>
                              Text.rich(TextSpan(children: <InlineSpan>[
                                TextSpan(text:'${controller.tempera}',style: const TextStyle(fontSize: 115)),
                                const TextSpan(text:"°",style: TextStyle(fontSize: 125)),
                              ])),
                          )
                      ),
                      Center(
                          child:Obx(()=>
                              Text.rich(TextSpan(children: <InlineSpan>[
                                TextSpan(text:'${controller.lowtemp}° / ${controller.hightemp}°',style: const TextStyle(fontSize: 22)),
                              ])),
                          )
                      ),
                      const SizedBox(height: 140),
                      //危险天气预警组件
                      buildWarning(),
                      const SizedBox(height: 65),
                      Container(
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width*0.05,
                            right: MediaQuery.of(context).size.width*0.05
                        ),
                        decoration: BoxDecoration(
                            color: themeColor(),
                            borderRadius: const BorderRadius.all(Radius.circular(15)),
                            boxShadow: [boxShadows()]
                        ),
                        child:
                          Row(
                            children: [
                              const SizedBox(width: 13),
                              Column(
                                children: [
                                  const Padding(padding: EdgeInsets.only(top:11)),
                                  const Text('风力等级',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                                  Text('${controller.windpower}级',style: const TextStyle(fontSize: 16)),
                                  const Padding(padding: EdgeInsets.only(top:11)),
                                ]
                              ),
                              const Spacer(flex: 1),
                              Column(
                                children: [
                                  const Padding(padding: EdgeInsets.only(top:11)),
                                  const Text('当前风向',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                                  Text('${controller.winddirection}',style: const TextStyle(fontSize: 16)),
                                  const Padding(padding: EdgeInsets.only(top:11)),
                                ]
                              ),
                              const Spacer(flex: 1),
                              Column(
                                children: [
                                  const Padding(padding: EdgeInsets.only(top:11)),
                                  const Text('空气湿度',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                                  Text('~${controller.humidity}%',style: const TextStyle(fontSize: 16)),
                                  const Padding(padding: EdgeInsets.only(top:11)),
                                ],
                              ),
                              const SizedBox(width: 13),
                            ],
                          )
                      ),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(  //未来天气
                            constraints: BoxConstraints(
                                minWidth: MediaQuery.of(context).size.width*0.43,
                                maxWidth: MediaQuery.of(context).size.width*0.53,
                            ),
                            margin: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width*0.05,
                                right: MediaQuery.of(context).size.width*0.05,
                            ),
                            decoration: BoxDecoration(
                                color: themeColor(),
                                borderRadius: const BorderRadius.all(Radius.circular(15)),
                                boxShadow: [boxShadows()]
                            ),
                            child: Column(
                              children: <Widget>[
                                const SizedBox(height: 7),
                                buildRowDate(controller.day1date,controller.day1Week.value),
                                const SizedBox(height: 3),
                                buildRowWeather(controller.day1LowTemp, controller.day1HighTemp,controller.day1weather.value),
                                const Divider(),
                                buildRowDate(controller.day2date,controller.day2Week.value),
                                const SizedBox(height: 3),
                                buildRowWeather(controller.day2LowTemp, controller.day2HighTemp,controller.day2weather.value),
                                const Divider(),
                                buildRowDate(controller.day3date,controller.day3Week.value),
                                const SizedBox(height: 3),
                                buildRowWeather(controller.day3LowTemp, controller.day3HighTemp,controller.day3weather.value),
                                const SizedBox(height: 4),
                              ],
                            ),
                          ),
                          SizedBox(width: MediaQuery.of(context).size.width*0.02),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: <Widget>[
                                  Container(
                                    constraints: BoxConstraints(
                                        minWidth: MediaQuery.of(context).size.width*0.30,
                                        maxWidth: MediaQuery.of(context).size.width*0.30,
                                    ),
                                    margin: EdgeInsets.only(
                                      right: MediaQuery.of(context).size.width*0.05,
                                    ),
                                    decoration: BoxDecoration(
                                        color: themeColor(),
                                        borderRadius: const BorderRadius.all(Radius.circular(15)),
                                        boxShadow: [boxShadows()]
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        const SizedBox(height: 9),
                                        buildIndices(controller.airQuality.value,"空气质量",Icons.air_outlined),
                                        const Divider(),
                                        buildIndices(controller.sportIndice.value,"运动指数",Icons.sports_tennis),
                                        const Divider(),
                                        buildIndices(controller.carWashIndice.value,"洗车指数",Icons.car_crash_outlined),
                                        const SizedBox(height: 9),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ]
                          ),
                        ],
                      ),
                      const Padding(padding: EdgeInsets.only(top:50)),
                    ],
                  ),
                ),
        )
      )
    );
  }

  //预警判断
  Widget buildWarning(){
    if(controller.weatherWarning.value == "无" || controller.weatherWarning.value == ""){
      return const Padding(padding: EdgeInsets.only(top:28));
    }
    return Container(
      constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width*0.9,maxWidth: MediaQuery.of(context).size.width*0.95),
      margin: EdgeInsets.only(
        left: MediaQuery.of(context).size.width*0.05,
        right: MediaQuery.of(context).size.width*0.05
      ),
      decoration: BoxDecoration(
        color: themeColor(),
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        boxShadow: [boxShadows()]
      ),
      child:Container(
        padding: const EdgeInsets.all(9),
        child: Column(
          children: <Widget>[
            ExpandableText(
              controller.weatherWarning.value,
              maxLines: 1,
              expanded: false,
              expandOnTextTap: true,
              collapseOnTextTap: true,
              linkColor: Colors.blueAccent,
              expandText: '展开',
              collapseText: '收起',
              animation: true,
            ),
          ],
        ),
      ),
    );
  }
}
