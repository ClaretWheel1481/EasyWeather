import 'package:easyweather/search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easyweather/function.dart';
import 'package:easyweather/controller.dart';
import 'package:easyweather/widgets.dart';
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red.shade50,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData.dark(
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark,
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
    return Obx(() => controller.cityname.value == '' && controller.weather.value == ''? //三目运算判断是否已经获取了城市
    Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.2),
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
        child: Text('点击右上角"搜索"，进行搜索城市。\n或点击右上角“定位”，获取您所在的城市。'),
      ),
    )
        :
    Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.2),
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

  Widget _buildDrawer() {
    return ListView(    //侧边栏
      padding: EdgeInsets.zero,
      children:  <Widget>[
        const DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Text('EasyWeather',style: TextStyle(fontSize:30,color: Color.fromRGBO(11, 129, 197, 1)))
        ),
        ExpansionTile(
          leading: const Icon(Icons.location_city_rounded),
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
                      showSnackbar("通知", "已删除${cityList[index]}！");
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
                setState(() {
                  Get.changeThemeMode(ThemeMode.light);
                });
              },
            ),
            ListTile(
              title: const Text('深色'),
              leading: const Icon(Icons.dark_mode),
              onTap: (){
                setState(() {
                  Get.changeThemeMode(ThemeMode.dark);
                });
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
                      applicationVersion: 'v1.0.6',
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
  } 

  Widget _getWeatherBody(){ //获取天气后改变的主页面
    //天气背景变化+过渡动画
    return Hero(
      tag: 'weather', 
      child: AnimatedSwitcher( 
              duration: const Duration(milliseconds: 800), 
              child: Container( 
                      key: ValueKey(weatherBackground[controller.weather.value]),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(weatherBackground[controller.weather.value] ?? "assets/images/cloudy.png"), 
                          fit: BoxFit.cover,
                          opacity: 0.7
                        )
                      ),
                      child: RefreshIndicator(  //下拉刷新
                        onRefresh:() async{
                          await Future.delayed(const Duration(milliseconds: 1300));
                          await getLocationWeather();
                          showSnackbar("通知", "更新天气成功！");
                        },
                        child: ListView(
                        controller: scrollAppbarController.scrollController,
                        children: <Widget>[
                          paddingContainer(20),
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
                          paddingContainer(140),
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
                                  TextSpan(text:'${controller.lowtemp}° / ${controller.hightemp}°',style: const TextStyle(fontSize: 24)),
                            ])),
                            )
                          ),
                          paddingContainer(130),
                          //危险天气预警组件
                          buildWarning(),
                          paddingContainer(50),
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
                                paddingContainer(8),
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
                          paddingContainer(50),
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
                                paddingContainer(8),
                                buildRowDate(controller.day1date,controller.day1week.value),
                                buildRowWeather(controller.day1lowtemp, controller.day1hightemp,controller.day1weather.value),
                                const Divider(),
                                buildRowDate(controller.day2date,controller.day2week.value),
                                buildRowWeather(controller.day2lowtemp, controller.day2hightemp,controller.day2weather.value),
                                const Divider(),
                                buildRowDate(controller.day3date,controller.day3week.value),
                                buildRowWeather(controller.day3lowtemp, controller.day3hightemp,controller.day3weather.value),
                                paddingContainer(5)
                              ],
                            ),
                          ),
                          paddingContainer(30),
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
      return paddingContainer(25);
    }
    return Container(
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
