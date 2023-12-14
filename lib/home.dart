import 'package:easyweather/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easyweather/function.dart';

List<String> cityList = []; //数据持久化天气列表

Mycontroller1 controller = Get.put(Mycontroller1());

Map<String,IconData> weatherIcons = {
    '晴' : Icons.sunny,
    '多云' : Icons.cloud,
    '阴' : CupertinoIcons.cloud,
    '小雨' : CupertinoIcons.cloud_rain,
    '中雨' : CupertinoIcons.cloud_rain,
    '大雨' : CupertinoIcons.cloud_rain,
    '暴雨' : CupertinoIcons.cloud_rain,
    '霾' : CupertinoIcons.infinite,
    '雾' : CupertinoIcons.cloud_fog_fill,
    '雪'  : Icons.snowing,
    '阵雪'  : Icons.snowing,
    '小雪'  : Icons.snowing,
    '中雪': CupertinoIcons.cloud_snow,
    '大雪': CupertinoIcons.cloud_snow_fill,
    '暴雪': CupertinoIcons.cloud_snow_fill,
    '雨夹雪' : CupertinoIcons.cloud_sleet,
};

Map<String,String> weeks = {
    '1' : '星期一',
    '2' : '星期二',
    '3' : '星期三',
    '4' : '星期四',
    '5' : '星期五',
    '6' : '星期六',
    '7' : '星期日',
};

class Mycontroller1 extends GetxController{
  var tempera = ''.obs; //当前温度
  var weather = ''.obs; //天气情况
  var cityname = ''.obs;  //选中的市或区、县名称
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
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'EasyWeather',
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.system,
      home: const MyHomePage(title: 'EasyWeather'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.weather.value == '' ? //三目运算判断是否已经获取了城市
    Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
        title: Text(widget.title),
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
        width: MediaQuery.of(context).size.width * 0.6,
        elevation: 3,
        child: _buildDrawer()
      ),
      body:const Center(
        child: Text('请先点击左上角"搜索"后，点击想查看的城市。'),
      ),
    )
        :
    Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
        title: Text(widget.title),
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
        width: MediaQuery.of(context).size.width * 0.6,
        elevation: 3,
        child: _buildDrawer(),
      ),
      body: _buildBody(),
      )
    );
  }

  Widget _buildDrawer() =>ListView(    //侧边栏
    padding: EdgeInsets.zero,
    children:  <Widget>[
      const DrawerHeader(
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/images/1.jpg'),
                fit: BoxFit.cover),
          ),
          child: Text('EasyWeather',style: TextStyle(fontSize:32,color: Color.fromRGBO(255, 140, 210, 1)))
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
                  getLocationWeather();
                  Get.back();
                  saveData();
                },
                onLongPress: (){
                  setState(() {
                    showSnackbar("通知", "您已删除${cityList[index]}！");
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
        title: const Text('深色/浅色模式'),
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
            leading: const Icon(Icons.brightness_4_outlined),
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
                    applicationVersion: 'v1.0.3',
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
          padding: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.2),
        ),
        Center(
          child:Obx(()=>
          Text.rich(TextSpan(children: <InlineSpan>[
            TextSpan(text:'${controller.tempera}',style: const TextStyle(fontSize: 108)),
            const TextSpan(text:"°",style: TextStyle(fontSize: 108)),
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
          padding: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.2),
        ),
        Container(
          margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width*0.05,
            right: MediaQuery.of(context).size.width*0.05
          ),
          decoration: BoxDecoration(
            color: themeColor(),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(52, 0, 0, 0),
                blurRadius: 4,
                spreadRadius: 1,
                offset: Offset(1, 2)
              )
            ]
          ),
          child: Column(
            children: <Widget>[
              Container(  //空白填充
                padding:const EdgeInsets.only(top:8),
              ),
              const Row(
                crossAxisAlignment:CrossAxisAlignment.center,
                children: <Widget>[
                  Text('   风力等级',style: TextStyle(fontSize: 20)),
                  Spacer(flex: 1),
                  Text('当前风向',style: TextStyle(fontSize: 20)),
                  Spacer(flex: 1),
                  Text('空气湿度   ',style: TextStyle(fontSize: 20)),
                ],
              ),
              Row(
                children: <Widget>[
                  const Text('    ',style: TextStyle(fontSize: 25)),
                  Text('  ${controller.windpower}级',style: const TextStyle(fontSize: 16)),
                  const Spacer(flex: 1),
                  Text('${controller.winddirection}',style: const TextStyle(fontSize: 16)),
                  const Spacer(flex: 1),
                  Text('${controller.humidity}%  ',style: const TextStyle(fontSize: 16)),
                  const Text('    ',style: TextStyle(fontSize: 25)),
                ],
              ),
              Container(  //空白填充
                padding:const EdgeInsets.only(bottom:5),
              ),
            ],
          ),
        ),
        Container(  //空白填充
          padding: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.1),
        ),
        Container(  //未来天气
          margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width*0.05,
            right: MediaQuery.of(context).size.width*0.05
          ),
          decoration: BoxDecoration(
            color: themeColor(),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(52, 0, 0, 0),
                blurRadius: 4,
                spreadRadius: 1,
                offset: Offset(1, 2)
              )
            ]
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
                    TextSpan(text:"  ${controller.day1date}  ${weeks[controller.day1week.value]}",style: const TextStyle(fontSize: 17)),
                  ]))
                ],
              ),
              Row(
                children: <Widget>[
                  Text.rich(TextSpan(children: <InlineSpan>[
                    const TextSpan(text:"  ",style: TextStyle(fontSize: 24)),
                    WidgetSpan(child: SizedBox(width: 18,height: 25,child: Icon(weatherIcons[controller.day1weather.value]))),
                    TextSpan(text:'  ${controller.day1weather}     ${controller.day1lowtemp}° ~ ${controller.day1hightemp}°',style: const TextStyle(fontSize: 25)),
                  ])),
                ],
              ),
              const Divider(),
              Row(
                children: <Widget>[
                  Text.rich(TextSpan(children: <InlineSpan>[
                    const TextSpan(text:"  ",style: TextStyle(fontSize: 24)),
                    const WidgetSpan(child: SizedBox(width: 18,height: 22,child: Icon(Icons.date_range))),
                    TextSpan(text:"  ${controller.day1date}  ${weeks[controller.day2week.value]}",style: const TextStyle(fontSize: 17)),
                  ]))
                ],
              ),
              Row(
                children: <Widget>[
                  Text.rich(TextSpan(children: <InlineSpan>[
                    const TextSpan(text:"  ",style: TextStyle(fontSize: 24)),
                    WidgetSpan(child: SizedBox(width: 18,height: 25,child: Icon(weatherIcons[controller.day2weather.value]))),
                    TextSpan(text:'  ${controller.day2weather}     ${controller.day2lowtemp}° ~ ${controller.day2hightemp}°',style: const TextStyle(fontSize: 25)),
                  ])),
                ],
              ),
              const Divider(),
              Row(
                children: <Widget>[
                  Text.rich(TextSpan(children: <InlineSpan>[
                    const TextSpan(text:"  ",style: TextStyle(fontSize: 24)),
                    const WidgetSpan(child: SizedBox(width: 18,height: 22,child: Icon(Icons.date_range))),
                    TextSpan(text:"  ${controller.day1date}  ${weeks[controller.day3week.value]}",style: const TextStyle(fontSize: 17)),
                  ]))
                ],
              ),
              Row(
                children: <Widget>[
                  Text.rich(TextSpan(children: <InlineSpan>[
                    const TextSpan(text:"  ",style: TextStyle(fontSize: 24)),
                    WidgetSpan(child: SizedBox(width: 18,height: 25,child: Icon(weatherIcons[controller.day3weather.value]))),
                    TextSpan(text:'  ${controller.day3weather}     ${controller.day3lowtemp}° ~ ${controller.day3hightemp}°',style: const TextStyle(fontSize: 25)),
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

  // 加载中Body
  Widget _notYetGetWeatherBody(){
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  // 加载数据成功/加载中Body
  Widget _buildBody(){
    if((controller.hightemp.value == ""||controller.day3weather.value == "") && controller.cityname.value != ""){
      return _notYetGetWeatherBody();
    }
    return _getWeatherBody();
  }

  // 根据状态改变部分组件的颜色
  Color themeColor(){
    if(Get.isDarkMode){
      return const Color.fromARGB(183, 56, 56, 56);
    }
    return const Color.fromARGB(242, 255, 255, 255);
  }
}
