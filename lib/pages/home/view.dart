import 'package:easyweather/pages/search/controller.dart';
import 'package:easyweather/pages/search/view.dart';
import 'package:easyweather/pages/settings/view.dart';
import 'package:easyweather/services/location.dart';
import 'package:easyweather/services/notify.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easyweather/services/weather.dart';
import 'package:easyweather/pages/home/widgets.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:easyweather/constants/items.dart';

List<String> cityList = []; //数据持久化天气列表

WeatherController wCtr = Get.put(WeatherController());
CityController cityQueryController = Get.put(CityController());

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final WeatherService weatherService = WeatherService();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => wCtr.locality.value.isEmpty
          ? _buildInitialScaffold()
          : _buildWeatherScaffold(),
    );
  }

  // 若天气为空则显示该组件
  Scaffold _buildInitialScaffold() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("EasyWeather"),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => const Settings());
            },
            icon: const Icon(Icons.settings),
          ),
          IconButton(
            onPressed: () async {
              requestLocationPermission(context);
            },
            icon: const Icon(Icons.location_on_outlined),
          ),
          IconButton(
            onPressed: () {
              Get.to(() => const Search());
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: const Center(
        child: Text('右上角"搜索"可搜索城市。\n或“定位”，获取您所在的城市。'),
      ),
    );
  }

  // 天气不为空显示该组件
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
                // 根据天气情况不同显示不同的背景
                key: ValueKey<String>(weatherBackground[wCtr.weather.value] ??
                    "assets/images/sunny.jpg"),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(weatherBackground[wCtr.weather.value] ??
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
          // 异步构建View
          FutureBuilder(
            future: weatherService.getLocationWeather(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  // 网络加载组件
                  child: CircularProgressIndicator(),
                );
              } else {
                return RefreshIndicator(
                  displacement: 50,
                  onRefresh: () async {
                    weatherService.clearCache();
                    await weatherService.getLocationWeather();
                  },
                  // 可滚动页面
                  child: CustomScrollView(
                    slivers: [
                      _buildSliverAppBar(),
                      _getWeatherBody(),
                    ],
                  ),
                );
              }
            },
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
            Obx(() => Text(wCtr.cityname.value,
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold))),
            Obx(
              () => Row(
                children: [
                  Icon(weatherIcons[wCtr.weather.value], size: 14),
                  const SizedBox(width: 4),
                  Text(
                    "${wCtr.weather}",
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        IconButton(
          onPressed: () {
            Get.to(() => const Settings());
          },
          icon: const Icon(Icons.settings),
        ),
        _buildPopupMenuButton(),
        IconButton(
          onPressed: () async {
            requestLocationPermission(context);
          },
          icon: const Icon(Icons.location_on_outlined),
        ),
        IconButton(
          onPressed: () {
            Get.to(() => const Search());
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
                showNotification("通知", "已删除$e！");
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
        wCtr.locality.value = value;
        weatherService.clearCache();
        Get.back();
        showNotification("通知", "当前默认城市为$value！");
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
          const SizedBox(height: 150),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(
                  () => Text.rich(
                    TextSpan(
                      children: <InlineSpan>[
                        TextSpan(
                          text: '${wCtr.tempera}',
                          style: const TextStyle(fontSize: 125),
                        ),
                        const TextSpan(
                          text: "°c",
                          style: TextStyle(fontSize: 25),
                        ),
                      ],
                    ),
                  ),
                ),
                Obx(
                  () => Text.rich(
                    TextSpan(
                      children: <InlineSpan>[
                        TextSpan(
                          text: '${wCtr.lowtemp}° / ${wCtr.hightemp}°',
                          style: const TextStyle(fontSize: 22),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 140),
          //危险天气预警组件
          Obx(() => _buildWarning()),
          const SizedBox(height: 55),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
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
            child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 13.0),
                child: Obx(() => Row(
                      children: [
                        buildWeatherInfo('风力等级', '${wCtr.windpower}级'),
                        const Spacer(flex: 1),
                        buildWeatherInfo('当前风向', '${wCtr.winddirection}'),
                        const Spacer(flex: 1),
                        buildWeatherInfo('空气湿度', '~${wCtr.humidity}%'),
                      ],
                    ))),
          ),
          const SizedBox(height: 50),
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    flex: 5,
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.05,
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
                      child: Obx(
                        () => Column(
                          children: <Widget>[
                            const SizedBox(height: 9),
                            for (int i = 0;
                                i < wCtr.futureWeather.length;
                                i++) ...[
                              buildRowDate(wCtr.futureWeather[i].date,
                                  wCtr.futureWeather[i].week.value),
                              const SizedBox(height: 3),
                              buildRowWeather(
                                wCtr.futureWeather[i].lowTemp,
                                wCtr.futureWeather[i].highTemp,
                                wCtr.futureWeather[i].weather,
                              ),
                              if (i < wCtr.futureWeather.length - 1)
                                const Divider(),
                            ],
                            const SizedBox(height: 5),
                          ],
                        ),
                      ),
                    )),
                SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: EdgeInsets.only(
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
                    child: Obx(
                      () => Column(
                        children: <Widget>[
                          const SizedBox(height: 9),
                          buildIndices(wCtr.airQuality.value, "空气质量",
                              Icons.air_outlined),
                          const SizedBox(height: 4),
                          const Divider(),
                          buildIndices(wCtr.sportIndice.value, "运动指数",
                              Icons.sports_tennis),
                          const SizedBox(height: 4),
                          const Divider(),
                          buildIndices(wCtr.carWashIndice.value, "洗车指数",
                              Icons.car_crash_outlined),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 50)),
        ],
      ),
    );
  }

  //预警判断
  Widget _buildWarning() {
    if (wCtr.weatherWarning.value == "无" || wCtr.weatherWarning.value == "") {
      return const Padding(padding: EdgeInsets.only(top: 25));
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
              wCtr.weatherWarning.value,
              maxLines: 2,
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
