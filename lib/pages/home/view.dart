import 'package:easyweather/pages/search/controller.dart';
import 'package:easyweather/pages/search/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easyweather/utils/function.dart';
import 'package:easyweather/pages/home/widgets.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:easyweather/utils/items.dart';

List<String> cityList = []; //数据持久化天气列表

WeatherController controller = Get.put(WeatherController());
CityController cityQueryController = Get.put(CityController());

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.locality.value.isEmpty
          ? _buildInitialScaffold()
          : _buildWeatherScaffold(),
    );
  }

  Scaffold _buildInitialScaffold() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("EasyWeather"),
        actions: [
          IconButton(
            onPressed: () async {
              requestLocationPermission();
            },
            icon: const Icon(Icons.location_on_outlined),
          ),
          IconButton(
            onPressed: () {
              Get.to(() => const Search(), transition: Transition.cupertino);
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: const Center(
        child: Text('点击右上角"搜索"，进行搜索城市。\n或点击右上角“定位”，获取您所在的城市。'),
      ),
    );
  }

  Scaffold _buildWeatherScaffold() {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(seconds: 1),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: Container(
                key: ValueKey<String>(
                    weatherBackground[controller.weather.value] ??
                        "assets/images/sunny.jpg"),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        weatherBackground[controller.weather.value] ??
                            "assets/images/sunny.jpg"),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(Get.isDarkMode ? 0.5 : 0.7),
                      BlendMode.dstATop,
                    ),
                  ),
                ),
              ),
            ),
          ),
          RefreshIndicator(
            displacement: 50,
            onRefresh: () async {
              await getLocationWeather();
            },
            child: CustomScrollView(
              slivers: [
                _buildSliverAppBar(),
                _getWeatherBody(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      expandedHeight: 180.0,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 20, bottom: 5),
        collapseMode: CollapseMode.parallax,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() => Text(controller.cityname.value,
                style: const TextStyle(fontSize: 20))),
            Obx(
              () => Row(
                children: [
                  Icon(weatherIcons[controller.weather.value], size: 14),
                  const SizedBox(width: 4),
                  Text(
                    "${controller.weather}",
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        _buildPopupMenuButton(),
        IconButton(
          onPressed: () async {
            requestLocationPermission();
          },
          icon: const Icon(Icons.location_on_outlined),
        ),
        IconButton(
          onPressed: () {
            Get.to(() => const Search(), transition: Transition.cupertino);
          },
          icon: const Icon(Icons.search),
        ),
      ],
    );
  }

  PopupMenuButton<String> _buildPopupMenuButton() {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.location_city_rounded),
      itemBuilder: (context) => cityList.map((e) {
        return PopupMenuItem<String>(
          value: e,
          child: GestureDetector(
            onLongPress: () {
              setState(() {
                cityList.remove(e); // 删除长按的元素
                Get.back();
                showSnackbar("通知", "已删除$e！");
                saveData();
              });
            },
            child: Row(
              children: [
                const Icon(Icons.location_on),
                Text(e),
              ],
            ),
          ),
        );
      }).toList(),
      onSelected: (value) {
        controller.locality.value = value;
        getLocationWeather();
        Get.back();
        showSnackbar("通知", "当前默认城市为$value！");
        saveData();
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
    );
  }

  Widget _getWeatherBody() {
    return SliverToBoxAdapter(
      child: Column(
        children: <Widget>[
          const SizedBox(height: 120),
          Center(
              child: Obx(
            () => Text.rich(TextSpan(children: <InlineSpan>[
              TextSpan(
                  text: '${controller.tempera}',
                  style: const TextStyle(fontSize: 115)),
              const TextSpan(text: "°", style: TextStyle(fontSize: 125)),
            ])),
          )),
          Center(
              child: Obx(
            () => Text.rich(TextSpan(children: <InlineSpan>[
              TextSpan(
                  text: '${controller.lowtemp}° / ${controller.hightemp}°',
                  style: const TextStyle(fontSize: 22)),
            ])),
          )),
          const SizedBox(height: 140),
          //危险天气预警组件
          buildWarning(),
          const SizedBox(height: 65),
          Container(
              margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.05,
                  right: MediaQuery.of(context).size.width * 0.05),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSecondary,
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 13),
                  Column(children: [
                    const Padding(padding: EdgeInsets.only(top: 11)),
                    const Text('风力等级',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('${controller.windpower}级',
                        style: const TextStyle(fontSize: 16)),
                    const Padding(padding: EdgeInsets.only(top: 11)),
                  ]),
                  const Spacer(flex: 1),
                  Column(children: [
                    const Padding(padding: EdgeInsets.only(top: 11)),
                    const Text('当前风向',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('${controller.winddirection}',
                        style: const TextStyle(fontSize: 16)),
                    const Padding(padding: EdgeInsets.only(top: 11)),
                  ]),
                  const Spacer(flex: 1),
                  Column(
                    children: [
                      const Padding(padding: EdgeInsets.only(top: 11)),
                      const Text('空气湿度',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('~${controller.humidity}%',
                          style: const TextStyle(fontSize: 16)),
                      const Padding(padding: EdgeInsets.only(top: 11)),
                    ],
                  ),
                  const SizedBox(width: 13),
                ],
              )),
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                //未来天气
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width * 0.43,
                  maxWidth: MediaQuery.of(context).size.width * 0.53,
                ),
                margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.05,
                  right: MediaQuery.of(context).size.width * 0.05,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSecondary,
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4.0,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 7),
                    buildRowDate(
                        controller.day1date, controller.day1Week.value),
                    const SizedBox(height: 3),
                    buildRowWeather(controller.day1LowTemp,
                        controller.day1HighTemp, controller.day1weather.value),
                    const Divider(),
                    buildRowDate(
                        controller.day2date, controller.day2Week.value),
                    const SizedBox(height: 3),
                    buildRowWeather(controller.day2LowTemp,
                        controller.day2HighTemp, controller.day2weather.value),
                    const Divider(),
                    buildRowDate(
                        controller.day3date, controller.day3Week.value),
                    const SizedBox(height: 3),
                    buildRowWeather(controller.day3LowTemp,
                        controller.day3HighTemp, controller.day3weather.value),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.02),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Row(
                  children: <Widget>[
                    Container(
                      constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width * 0.30,
                        maxWidth: MediaQuery.of(context).size.width * 0.30,
                      ),
                      margin: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width * 0.05,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSecondary,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4.0,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 9),
                          buildIndices(controller.airQuality.value, "空气质量",
                              Icons.air_outlined),
                          const Divider(),
                          buildIndices(controller.sportIndice.value, "运动指数",
                              Icons.sports_tennis),
                          const Divider(),
                          buildIndices(controller.carWashIndice.value, "洗车指数",
                              Icons.car_crash_outlined),
                          const SizedBox(height: 9),
                        ],
                      ),
                    ),
                  ],
                ),
              ]),
            ],
          ),
          const Padding(padding: EdgeInsets.only(top: 50)),
        ],
      ),
    );
  }

  //预警判断
  Widget buildWarning() {
    if (controller.weatherWarning.value == "无" ||
        controller.weatherWarning.value == "") {
      return const Padding(padding: EdgeInsets.only(top: 28));
    }
    return Container(
      constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width * 0.9,
          maxWidth: MediaQuery.of(context).size.width * 0.95),
      margin: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.05,
          right: MediaQuery.of(context).size.width * 0.05),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSecondary,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Container(
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
