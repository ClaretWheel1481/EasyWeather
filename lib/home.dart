import 'package:easyweather/search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Setting.dart';


class Mycontroller extends GetxController{
  var tempera = ''.obs;
  var province = ''.obs;
  var weather = ''.obs;
  var cityname = ''.obs;
  var query = "北京".obs;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(onPressed: (){
            Get.to(()=>const Search(),transition: Transition.cupertino);
          }, icon: const Icon(Icons.search))
        ],
      ),
      drawer: Drawer(
        elevation: 3,
        child: _buildChild(),
      ),
      body: Stack(
        children: <Widget>[
          // Positioned.fill(
          //   top:0,
          //   child: Image.asset('assets/images/1.jpg',fit: BoxFit.none,alignment: Alignment.topCenter,),
          // ),
          Positioned(
            left: 10,
            top: 5,
            child: Obx(()=>Text(
              '${controller.province},${controller.cityname}',
              style: const TextStyle(fontSize: 40),
              ),
            )
          ),
          Positioned(
            left:MediaQuery.of(context).size.width*0.65,
            top: MediaQuery.of(context).size.height*0.4,
            child: Obx(()=>Text(
              '${controller.tempera}°c',
              style: const TextStyle(fontSize: 66),
            ),
            )
          ),
          Positioned(
            left:10,
            top: 65,
            child: Row(
              children: <Widget>[
                Obx(()=>Text(
                  '${controller.weather}',
                  style: const TextStyle(fontSize: 28),
                   ),
                ),
              ],
            ),
          )
        ],
      )

    );
  }
  Widget _buildChild() =>ListView(
    padding: EdgeInsets.zero,
    children:  <Widget>[
      const DrawerHeader(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('images/1.jpg'),
              fit: BoxFit.cover),
        ),
        child: Text('EasyWeather',
            style: TextStyle(fontSize:24,color: Colors.blueAccent)
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
                  return const AlertDialog(
                    title: Text("关于 EasyWeather"),
                    content: Text("EasyWeather v0.0.1 由 Claret 制作, 数据来源 高德天气API. "),
                  );
                }
            );
          }
      ),
    ],
  );
}
