import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/models/city.dart';
import '../../core/models/weather.dart';
import '../../core/api/open_meteo_api.dart';
import '../../widgets/empty_city_tip.dart';
import '../../widgets/weather_view.dart';
import '../../core/services/weather_cache.dart';
import '../../core/notifiers.dart';
import '../../widgets/weather_bg.dart';
import 'dart:ui';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<City> cities = [];
  int pageIndex = 0;
  Map<String, WeatherData?> weatherMap = {};
  Map<String, bool> loadingMap = {};
  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    tempUnitNotifier.addListener(_onUnitChanged);
    _loadCities();
  }

  @override
  void dispose() {
    tempUnitNotifier.removeListener(_onUnitChanged);
    _pageController?.dispose();
    super.dispose();
  }

  void _onUnitChanged() {
    if (!mounted) return;
    for (var city in cities) {
      _loadWeather(city, force: true);
    }
  }

  Future<void> _loadCities() async {
    final prefs = await SharedPreferences.getInstance();
    final citiesStr = prefs.getString('cities');
    final mainIndex = prefs.getInt('main_city_index') ?? 0;
    List<City> list = [];
    int idx = 0;
    if (citiesStr != null) {
      list = City.listFromJson(citiesStr);
      idx = mainIndex < list.length ? mainIndex : 0;
      if (list.isNotEmpty && idx != 0) {
        final mainCity = list.removeAt(idx);
        list.insert(0, mainCity);
        idx = 0;
      }
    }
    if (!mounted) return;
    setState(() {
      cities = list;
      pageIndex = idx;
      _pageController = PageController(initialPage: idx);
    });
    if (cities.isNotEmpty) {
      for (var city in cities) {
        _loadWeather(city);
      }
    }
  }

  Future<void> _loadWeather(City city, {bool force = false}) async {
    if (!mounted) return;
    setState(() {
      loadingMap[city.cacheKey] = true;
    });
    WeatherData? cached;
    if (!force) {
      cached = await loadCachedWeather(city);
    }
    if (cached != null) {
      setState(() {
        weatherMap[city.cacheKey] = cached;
        loadingMap[city.cacheKey] = false;
      });
      // 后台刷新
      _refreshWeather(city);
    } else {
      await _refreshWeather(city);
    }
  }

  Future<void> _refreshWeather(City city) async {
    final unit = tempUnitNotifier.value == 'F' ? 'imperial' : 'metric';
    final data = await OpenMeteoApi.fetchWeather(
        latitude: city.lat, longitude: city.lon, units: unit);
    if (data != null) {
      await cacheWeather(city, data);
    }
    if (!mounted) return;
    setState(() {
      weatherMap[city.cacheKey] = data;
      loadingMap[city.cacheKey] = false;
    });
  }

  void _onPageChanged(int idx) async {
    if (!mounted) return;
    setState(() {
      pageIndex = idx;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('main_city_index', idx);
  }

  Future<void> _onAddCity() async {
    final result = await Navigator.pushNamed(context, '/search');
    if (result is City) {
      final prefs = await SharedPreferences.getInstance();
      // 读取原有城市列表
      final citiesStr = prefs.getString('cities');
      List<City> list = citiesStr != null ? City.listFromJson(citiesStr) : [];
      // 判断是否已存在
      int idx;
      if (!list.any((c) => c.lat == result.lat && c.lon == result.lon)) {
        list.add(result);
        idx = list.length - 1;
        await prefs.setString('cities', City.listToJson(list));
        await prefs.setInt('main_city_index', idx);
      } else {
        // 已存在则切换到该城市
        idx =
            list.indexWhere((c) => c.lat == result.lat && c.lon == result.lon);
        await prefs.setInt('main_city_index', idx);
      }
      await _loadCities();
      setState(() {
        pageIndex = 0;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _pageController?.jumpToPage(0);
      });
    }
  }

  Future<void> _onOpenSettings() async {
    final result = await Navigator.pushNamed(context, '/settings');
    if (result == true || result == null) {
      await _loadCities();
      setState(() {
        pageIndex = 0;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _pageController?.jumpToPage(0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentCity = cities.isNotEmpty && pageIndex < cities.length
        ? cities[pageIndex]
        : null;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AppBar(
              elevation: 0,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              title: Text(currentCity?.name ?? 'EasyWeather'),
              actions: [
                IconButton(
                    icon: const Icon(Icons.search), onPressed: _onAddCity),
                IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: _onOpenSettings),
              ],
            ),
          ),
        ),
      ),
      body: cities.isEmpty
          ? const EmptyCityTip()
          : PageView.builder(
              controller: _pageController,
              itemCount: cities.length,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, idx) {
                final city = cities[idx];
                final weather = weatherMap[city.cacheKey];
                final loading = loadingMap[city.cacheKey] ?? false;
                if (loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (weather == null) {
                  return const Center(
                      child: Text('天气数据加载失败',
                          style: TextStyle(color: Colors.white)));
                } else {
                  return Stack(
                    children: [
                      WeatherBg(weatherCode: weather.current?.weatherCode),
                      RefreshIndicator(
                        displacement: kToolbarHeight + 35,
                        onRefresh: () => _refreshWeather(city),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              SizedBox(height: kToolbarHeight + 35),
                              WeatherView(
                                city: city,
                                weather: weather,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
    );
  }
}
