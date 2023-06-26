import 'package:easyweather/search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Setting.dart';
import 'package:location_permissions/location_permissions.dart';


class Mycontroller extends GetxController{
  var tempera = ''.obs;
  var province = ''.obs;
  var weather = ''.obs;
  var cityname = ''.obs;
  var query = "北京".obs;
  var hightemp1 = ''.obs;
  var lowtemp1 = ''.obs;
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
  final Mycontroller controller = Get.put(Mycontroller());


  Widget _buildChild() =>ListView(
    padding: EdgeInsets.zero,
    children:  <Widget>[
      const DrawerHeader(
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/images/1.jpg'),
                fit: BoxFit.cover),
          ),
          child: Text('EasyWeather',
              style: TextStyle(fontSize:32,color: Color.fromRGBO(255, 140, 210, 1)),

          )
      ),
      ListTile(
        leading: const Icon(Icons.settings),
        title: const Text("设置"),
        onTap: (){
          Get.to(()=>const Setting(),transition: Transition.cupertino);
        },
      ),
      ListTile(
          leading: const Icon(Icons.help),
          title: const Text("关于"),
          onTap: (){
            showDialog(
                context: context,
                builder:(context){
                  return AboutDialog(
                    applicationIcon: Image.asset('assets/images/ic_launcher.png'),
                    applicationVersion: 'v0.0.2',
                    applicationName: 'EasyWeather',
                    children: const <Widget>[
                      Text('EasyWeather 数据来源 高德地图')
                    ],
                  );
                }
            );
          }
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.weather.value == '' ?
    Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(onPressed: () async {
            PermissionStatus permission = await LocationPermissions().requestPermissions();
          },
              icon: const Icon(Icons.location_on_outlined)
          ),
          IconButton(onPressed: (){
            Get.to(()=>const Search(),transition: Transition.cupertino);
          }, icon: const Icon(Icons.search))
        ],
      ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.8,
        elevation: 3,
        child: _buildChild()
      ),
      body:const Center(
        child: Text('请先进行"搜索城市"操作后,点击想查看的城市.'),
      ),
    )
        :
    Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(onPressed: () async {
            PermissionStatus permission = await LocationPermissions().requestPermissions();
          },
              icon: const Icon(Icons.location_on_outlined)
          ),
          IconButton(onPressed: (){
            Get.to(()=>const Search(),transition: Transition.cupertino);
          }, icon: const Icon(Icons.search))
        ],
      ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.7,
        elevation: 3,
        child: _buildChild(),
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
              left: 10,
              top: 5,
              child:Row(
                children: [
                  const Icon(Icons.location_on),
                  Obx(()=>Text(
                    '${controller.province},${controller.cityname}',
                    style: const TextStyle(fontSize: 28),
                  ),
                  )
                ],
              )
          ),
          Positioned(
              top: MediaQuery.of(context).size.height-220,
              left:MediaQuery.of(context).size.width-225,
              child: Stack(
                children: [
                  Obx(()=>Text(
                    '${controller.tempera}°c',
                    style: const TextStyle(fontSize: 108),),
                  ),
                  Positioned(
                    left: 100,
                    child: Obx(()=>Text(
                      '${controller.hightemp1}°c ~ ${controller.lowtemp1}°c',
                      style: const TextStyle(fontSize: 20),
                    ),
                    ),
                  ),
                ],
              )
          ),
          Positioned(
            left:15,
            top: 50,
            child: Row(
              children: [
                Icon(Icons.cloud),
                Obx(()=>Text(
                  '${controller.weather}',
                  style: const TextStyle(fontSize: 24),
                ),
                ),
              ],
            ),
          ),
        ],
      ),));
}}
