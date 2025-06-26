import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/models/city.dart';
import '../../core/models/weather.dart';
import '../../core/api/open_meteo_api.dart';
import 'widgets/empty_city_tip.dart';
import '../../core/services/weather_cache.dart';
import '../../core/notifiers.dart';
import 'widgets/home_app_bar_widget.dart';
import 'widgets/home_page_content_widget.dart';
import '../../core/services/location_service.dart';
import 'package:easyweather/l10n/generated/app_localizations.dart';
import '../../core/utils/notification_utils.dart';

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

    // 确保pageIndex在有效范围内
    if (list.isNotEmpty && idx >= list.length) {
      idx = 0;
    }

    setState(() {
      cities = list;
      pageIndex = idx;
      // 只有在PageController不存在或城市列表发生变化时才重新创建
      if (_pageController == null || _pageController!.hasClients == false) {
        _pageController = PageController(initialPage: idx);
      }
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
    if (idx >= 0 && idx < cities.length) {
      setState(() {
        pageIndex = idx;
      });
    }
  }

  Future<void> _onAddCity() async {
    final result = await Navigator.pushNamed(context, '/search');
    if (result is City) {
      final prefs = await SharedPreferences.getInstance();
      // 读取原有城市列表
      final citiesStr = prefs.getString('cities');
      List<City> list = citiesStr != null ? City.listFromJson(citiesStr) : [];
      // 判断是否已存在
      if (!list.any((c) => c.lat == result.lat && c.lon == result.lon)) {
        list.add(result);
        await prefs.setString('cities', City.listToJson(list));
      }

      // 重新加载城市列表
      await _loadCities();

      // 重新查找新城市的下标（包括已存在的情况）
      final citiesStr2 = prefs.getString('cities');
      List<City> list2 =
          citiesStr2 != null ? City.listFromJson(citiesStr2) : [];
      int newIdx =
          list2.indexWhere((c) => c.lat == result.lat && c.lon == result.lon);

      if (newIdx >= 0 && newIdx < cities.length) {
        setState(() {
          pageIndex = newIdx;
        });

        // 确保PageController已经创建并且页面已经构建完成后再跳转
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_pageController != null && _pageController!.hasClients) {
            _pageController!.animateToPage(
              newIdx,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        });
      }
    }
  }

  Future<void> _onOpenSettings() async {
    final result = await Navigator.pushNamed(context, '/settings');
    if (result == 'mainCityChanged' ||
        result == 'cityListChanged' ||
        result == 'tempUnitChanged') {
      await _loadCities();
      setState(() {
        pageIndex = 0;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _pageController?.jumpToPage(0);
      });
    }
  }

  Future<void> _onLocate() async {
    NotificationUtils.showSnackBar(
      context,
      AppLocalizations.of(context).locating,
    );
    final pos = await LocationService.getCurrentPosition();
    if (pos == null) {
      if (!mounted) return;
      NotificationUtils.showSnackBar(
        context,
        AppLocalizations.of(context).locationPermissionDenied,
      );
      return;
    } else {
      kDebugMode ? debugPrint(pos.latitude.toString()) : null;
      if (!mounted) return;
      NotificationUtils.showSnackBar(
        context,
        AppLocalizations.of(context).locatingSuccess,
      );
    }
    final city = await LocationService.getCityFromPosition(pos);
    kDebugMode ? debugPrint(city.name) : null;
    final prefs = await SharedPreferences.getInstance();
    if (city.name.isEmpty) {
      if (!mounted) return;
      NotificationUtils.showSnackBar(
        context,
        AppLocalizations.of(context).locationNotRecognized,
      );
      return;
    }
    final citiesStr = prefs.getString('cities');
    List<City> list = citiesStr != null ? City.listFromJson(citiesStr) : [];
    if (!list.any((c) => c.lat == city.lat && c.lon == city.lon)) {
      list.add(city);
      await prefs.setString('cities', City.listToJson(list));
      await _loadCities();
      final citiesStr2 = prefs.getString('cities');
      List<City> list2 =
          citiesStr2 != null ? City.listFromJson(citiesStr2) : [];
      int newIdx =
          list2.indexWhere((c) => c.lat == city.lat && c.lon == city.lon);
      if (newIdx >= 0 && newIdx < cities.length) {
        setState(() {
          pageIndex = newIdx;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_pageController != null && _pageController!.hasClients) {
            _pageController!.animateToPage(
              newIdx,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        });
      }
    } else {
      // 城市已存在，直接跳转到该城市
      int existIdx =
          list.indexWhere((c) => c.lat == city.lat && c.lon == city.lon);
      if (existIdx >= 0 && existIdx < cities.length) {
        setState(() {
          pageIndex = existIdx;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_pageController != null && _pageController!.hasClients) {
            _pageController!.animateToPage(
              existIdx,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentCity = cities.isNotEmpty && pageIndex < cities.length
        ? cities[pageIndex]
        : null;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: HomeAppBarWidget(
        currentCityName: currentCity?.name,
        citiesLength: cities.length,
        pageIndex: pageIndex,
        onAddCity: _onAddCity,
        onOpenSettings: _onOpenSettings,
        onLocate: _onLocate,
      ),
      body: cities.isEmpty
          ? EmptyCityTip(onLocate: _onLocate)
          : PageView.builder(
              controller: _pageController,
              itemCount: cities.length,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, idx) {
                final city = cities[idx];
                final weather = weatherMap[city.cacheKey];
                final loading = loadingMap[city.cacheKey] ?? false;
                return HomePageContentWidget(
                  city: city,
                  weather: weather,
                  loading: loading,
                  onRefresh: () => _refreshWeather(city),
                );
              },
            ),
    );
  }
}
