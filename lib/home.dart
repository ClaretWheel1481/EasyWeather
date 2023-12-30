import 'package:easyweather/search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easyweather/function.dart';
import 'package:easyweather/controller.dart';
import 'package:easyweather/widgets.dart';
import 'package:easyweather/items.dart';

List<String> cityList = []; //数据持久化天气列表

//伟大的controller!
weatherController controller = Get.put(weatherController());
animateController scrollAppbarController = Get.put(animateController());
CityController cityQueryController = Get.put(CityController());

class MyApp extends StatelessWidget {

  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData.light(
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.cityname.value == '' ? //三目运算判断是否已经获取了城市
    Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
        title: const Text("EasyWeather"),
        actions: <Widget>[
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
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.65,
        elevation: 3,
        child: _buildDrawer()
      ),
      body:const Center(
        child: Text('点击右上角"搜索"，进行搜索城市。'),
      ),
    )
        :
    Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
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
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.65,
        elevation: 3,
        child: _buildDrawer(),
      ),
      body: _getWeatherBody(),
      )
    );
  }

  Widget _buildDrawer() => ListView(    //侧边栏
    padding: EdgeInsets.zero,
    children:  <Widget>[
      const DrawerHeader(
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/images/1.jpg'),
                fit: BoxFit.cover),
          ),
          child: Text('EasyWeather',style: TextStyle(fontSize:30,color: Color.fromRGBO(11, 129, 197, 1)))
      ),
      ExpansionTile(
        leading: const Icon(Icons.apartment_outlined),
        title: const Text('城市列表'),
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: cityList.length,
            itemBuilder: (context,index){
              return ListTile(
                leading: const Icon(Icons.location_on),
                title: Text(cityList[index]),
                onTap: (){
                  controller.locality.value = cityList[index];
                  Get.back();
                  getLocationWeather();
                  scrollAppbarController.scrollToTop();
                  saveData();
                },
                onLongPress: (){
                  setState(() {
                    showSnackbar("⚠️通知", "已删除${cityList[index]}！");
                    cityList.remove(cityList[index]);
                    saveData();
                  });
                },
              );
            }
          )
        ],
      ),
      ExpansionTile(
        leading: const Icon(Icons.brightness_4),
        title: const Text('主题'),
        children: [
          ListTile(
            title: const Text('浅色'),
            leading: const Icon(Icons.light_mode),
            onTap: (){
              Get.changeThemeMode(ThemeMode.light);
            },
          ),
          ListTile(
            title: const Text('深色'),
            leading: const Icon(Icons.dark_mode),
            onTap: (){
              Get.changeThemeMode(ThemeMode.dark);
            },
          ),
          ListTile(
            title: const Text('跟随系统设置'),
            leading: const Icon(Icons.brightness_4_rounded),
            onTap: (){
              Get.changeThemeMode(ThemeMode.system);
            },
          ),
        ],
      ),
      ListTile(
          leading: const Icon(Icons.help),
          title: const Text("关于"),
          onTap: (){
            showDialog(
                context: context,
                builder:(context){
                  return const AboutDialog(
                    applicationIcon: Image(image: AssetImage('assets/images/easyweather.png'),width: 50,),
                    applicationVersion: 'v1.0.4',
                    applicationName: 'EasyWeather',
                    children: <Widget>[
                      Text('EasyWeather数据来源高德开放平台、和风天气。')
                    ],
                  );
                }
            );
          }
      ),
    ],
  );

  Widget _getWeatherBody(){ //获取天气后改变的主页面
    return ListView(
      controller: scrollAppbarController.scrollController,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(top:20),
        ),
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
        Container(
          padding: const EdgeInsets.only(top:140),
        ),
        Center(
          child:Obx(()=>
          Text.rich(TextSpan(children: <InlineSpan>[
            TextSpan(text:'${controller.tempera}',style: const TextStyle(fontSize: 108)),
            const TextSpan(text:"°",style: TextStyle(fontSize: 118)),
          ])),
          )
        ),
        Center(
          child:Obx(()=>
          Text.rich(TextSpan(children: <InlineSpan>[
                TextSpan(text:'${controller.lowtemp}° / ${controller.hightemp}°',style: const TextStyle(fontSize: 24)),
          ])),
          )
        ),
        Container(
          padding: const EdgeInsets.only(top:140),
        ),
        //TODO:危险天气预警
        // _buildWarning(),
        Container(
          padding: const EdgeInsets.only(top:50),
        ),
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
          child: Column(
            children: <Widget>[
              Container(  //空白填充
                padding:const EdgeInsets.only(top:8),
              ),
              const Row(
                crossAxisAlignment:CrossAxisAlignment.center,
                children: <Widget>[
                  Text('   风力等级',style: TextStyle(fontSize: 18)),
                  Spacer(flex: 1),
                  Text('当前风向',style: TextStyle(fontSize: 18)),
                  Spacer(flex: 1),
                  Text('空气湿度   ',style: TextStyle(fontSize: 18)),
                ],
              ),
              Row(
                children: <Widget>[
                  const Text('    ',style: TextStyle(fontSize: 21)),
                  Text('  ${controller.windpower}级',style: const TextStyle(fontSize: 16)),
                  const Spacer(flex: 1),
                  Text('${controller.winddirection}',style: const TextStyle(fontSize: 16)),
                  const Spacer(flex: 1),
                  Text('${controller.humidity}%  ',style: const TextStyle(fontSize: 16)),
                  const Text('    ',style: TextStyle(fontSize: 21)),
                ],
              ),
              Container(  //空白填充
                padding:const EdgeInsets.only(bottom:5),
              ),
            ],
          ),
        ),
        Container(  //空白填充
          padding: const EdgeInsets.only(top:50),
        ),
        Container(  //未来天气
          margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width*0.05,
            right: MediaQuery.of(context).size.width*0.05
          ),
          decoration: BoxDecoration(
            color: themeColor(),
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            boxShadow: [boxShadows()]
          ),
          child: Column(
            children: <Widget>[
              Container(  //空白填充
                padding: const EdgeInsets.only(top:8),
              ),
              Row(
                children: <Widget>[
                  Text.rich(TextSpan(children: <InlineSpan>[
                    const TextSpan(text:"  ",style: TextStyle(fontSize: 24)),
                    const WidgetSpan(child: SizedBox(width: 18,height: 22,child: Icon(Icons.date_range))),
                    TextSpan(text:"  ${controller.day1date}  ${weeks[controller.day1week.value]}",style: const TextStyle(fontSize: 18)),
                  ]))
                ],
              ),
              Row(
                children: <Widget>[
                  Text.rich(TextSpan(children: <InlineSpan>[
                    const TextSpan(text:"  ",style: TextStyle(fontSize: 24)),
                    WidgetSpan(child: SizedBox(width: 16,height: 26,child: Icon(weatherIcons[controller.day1weather.value]))),
                    WidgetSpan(child: ConstrainedBox(constraints: const BoxConstraints(minWidth: 95),child:Container(padding: const EdgeInsets.only(right:40),child: Text('   ${controller.day1weather}',style: const TextStyle(fontSize: 18))))),
                    TextSpan(text: '     ${controller.day1lowtemp}° ~ ${controller.day1hightemp}°',style: const TextStyle(fontSize: 22)),
                  ])),
                ],
              ),
              const Divider(),
              Row(
                children: <Widget>[
                  Text.rich(TextSpan(children: <InlineSpan>[
                    const TextSpan(text:"  ",style: TextStyle(fontSize: 24)),
                    const WidgetSpan(child: SizedBox(width: 18,height: 22,child: Icon(Icons.date_range))),
                    TextSpan(text:"  ${controller.day2date}  ${weeks[controller.day2week.value]}",style: const TextStyle(fontSize: 18)),
                  ]))
                ],
              ),
              Row(
                children: <Widget>[
                  Text.rich(TextSpan(children: <InlineSpan>[
                    const TextSpan(text:"  ",style: TextStyle(fontSize: 24)),
                    WidgetSpan(child: SizedBox(width: 16,height: 26,child: Icon(weatherIcons[controller.day2weather.value]))),
                    WidgetSpan(child: ConstrainedBox(constraints: const BoxConstraints(minWidth: 95),child:Container(padding: const EdgeInsets.only(right:40),child: Text('   ${controller.day2weather}',style: const TextStyle(fontSize: 18))))),
                    TextSpan(text: '     ${controller.day2lowtemp}° ~ ${controller.day2hightemp}°',style: const TextStyle(fontSize: 22)),
                  ])),
                ],
              ),
              const Divider(),
              Row(
                children: <Widget>[
                  Text.rich(TextSpan(children: <InlineSpan>[
                    const TextSpan(text:"  ",style: TextStyle(fontSize: 24)),
                    const WidgetSpan(child: SizedBox(width: 18,height: 22,child: Icon(Icons.date_range))),
                    TextSpan(text:"  ${controller.day3date}  ${weeks[controller.day3week.value]}",style: const TextStyle(fontSize: 18)),
                  ])),
                ],
              ),
              Row(
                children: <Widget>[
                  Text.rich(TextSpan(children: <InlineSpan>[
                    const TextSpan(text:"  ",style: TextStyle(fontSize: 24)),
                    WidgetSpan(child: SizedBox(width: 16,height: 26,child: Icon(weatherIcons[controller.day3weather.value]))),
                    WidgetSpan(child: ConstrainedBox(constraints: const BoxConstraints(minWidth: 95),child:Container(padding: const EdgeInsets.only(right:40),child: Text('   ${controller.day3weather}',style: const TextStyle(fontSize: 18))))),
                    TextSpan(text: '     ${controller.day3lowtemp}° ~ ${controller.day3hightemp}°',style: const TextStyle(fontSize: 22)),
                  ])),
                ],
              ),
              Container(  //空白填充
                padding: const EdgeInsets.only(top:5),
              ),
            ],
          ),
        ),
        Container(  //空白填充
          padding: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.1),
        ),
      ],
    );
  }

  //预警判断
  // Widget _buildWarning(){
  //   return Container(
  //     margin: EdgeInsets.only(
  //       left: MediaQuery.of(context).size.width*0.05,
  //       right: MediaQuery.of(context).size.width*0.05
  //     ),
  //     decoration: BoxDecoration(
  //       color: themeColor(),
  //       borderRadius: const BorderRadius.all(Radius.circular(15)),
  //       boxShadow: [boxShadows()]
  //     ),
  //     child:Container(
  //       padding: const EdgeInsets.all(8),
  //       child: Column(
  //         children: <Widget>[
  //           Text.rich(TextSpan(children: <InlineSpan>[
  //             TextSpan(text: "泉州市气象台2023年12月15日21时22分发布大风黄色预警信号：受冷空气影响，预计未来12小时我市沿海有8～9级东北大风。请注意防范！")
  //           ])),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
