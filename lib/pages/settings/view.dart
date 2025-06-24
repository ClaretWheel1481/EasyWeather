import 'package:easyweather/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import '../../core/models/city.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  ThemeMode? _themeMode;
  String? _tempUnit;
  bool _loading = true;
  bool _dynamicColorEnabled = false;
  // 城市管理相关
  List<City> _cities = [];
  int _mainCityIndex = 0;
  bool _cityLoading = true;
  bool _cityManagerExpanded = false;
  bool _cityChanged = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadCities();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _themeMode = ThemeMode.values[prefs.getInt('theme_mode') ?? 2];
      _tempUnit = prefs.getString('temp_unit') ?? 'C';
      _dynamicColorEnabled = prefs.getBool('dynamic_color_enabled') ?? false;
      _loading = false;
    });
    dynamicColorEnabledNotifier.value = _dynamicColorEnabled;
  }

  Future<void> _loadCities() async {
    final prefs = await SharedPreferences.getInstance();
    final citiesStr = prefs.getString('cities');
    final mainIndex = prefs.getInt('main_city_index') ?? 0;
    if (citiesStr != null) {
      setState(() {
        _cities = City.listFromJson(citiesStr);
        _mainCityIndex = mainIndex < _cities.length ? mainIndex : 0;
        _cityLoading = false;
      });
    } else {
      setState(() {
        _cities = [];
        _mainCityIndex = 0;
        _cityLoading = false;
      });
    }
  }

  Future<void> _saveCities() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cities', City.listToJson(_cities));
    await prefs.setInt('main_city_index', _mainCityIndex);
  }

  void _removeCity(int index) async {
    if (_cities.isEmpty) return;
    setState(() {
      _cities.removeAt(index);
      if (_mainCityIndex >= _cities.length) {
        _mainCityIndex = 0;
      }
      _cityChanged = true;
    });
    await _saveCities();
  }

  void _setMainCity(int index) async {
    setState(() {
      _mainCityIndex = index;
      _cityChanged = true;
    });
    await _saveCities();
  }

  Future<void> _saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme_mode', mode.index);
    setState(() {
      _themeMode = mode;
    });
    themeModeNotifier.value = mode;
  }

  Future<void> _saveTempUnit(String unit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('temp_unit', unit);
    setState(() {
      _tempUnit = unit;
    });
    tempUnitNotifier.value = unit;
  }

  Future<void> _saveDynamicColorEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dynamic_color_enabled', enabled);
    setState(() {
      _dynamicColorEnabled = enabled;
    });
    dynamicColorEnabledNotifier.value = enabled;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('设置')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(_cityChanged);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('设置'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop(_cityChanged);
            },
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('主题模式', style: textTheme.titleMedium),
                    const SizedBox(height: 12),
                    SegmentedButton<ThemeMode>(
                      segments: const [
                        ButtonSegment(
                            value: ThemeMode.system,
                            label: Text('跟随系统'),
                            icon: Icon(Icons.phone_android)),
                        ButtonSegment(
                            value: ThemeMode.light,
                            label: Text('明亮'),
                            icon: Icon(Icons.light_mode)),
                        ButtonSegment(
                            value: ThemeMode.dark,
                            label: Text('暗色'),
                            icon: Icon(Icons.dark_mode)),
                      ],
                      selected: {_themeMode ?? ThemeMode.system},
                      onSelectionChanged: (modes) {
                        if (modes.isNotEmpty) _saveThemeMode(modes.first);
                      },
                      showSelectedIcon: false,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Row(
                  children: [
                    Icon(Icons.palette_outlined,
                        color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Text('Monet取色', style: textTheme.titleMedium)),
                    Switch(
                      value: _dynamicColorEnabled,
                      onChanged: (v) => _saveDynamicColorEnabled(v),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('温度单位', style: textTheme.titleMedium),
                    const SizedBox(height: 12),
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(
                            value: 'C',
                            label: Text('摄氏度 (°C)'),
                            icon: Icon(Icons.thermostat)),
                        ButtonSegment(
                            value: 'F',
                            label: Text('华氏度 (°F)'),
                            icon: Icon(Icons.device_thermostat)),
                      ],
                      selected: {_tempUnit ?? 'C'},
                      onSelectionChanged: (units) {
                        if (units.isNotEmpty) _saveTempUnit(units.first);
                      },
                      showSelectedIcon: false,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      setState(() {
                        _cityManagerExpanded = !_cityManagerExpanded;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      child: Row(
                        children: [
                          Icon(Icons.location_city,
                              color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 8),
                          Text('城市管理', style: textTheme.titleMedium),
                          const Spacer(),
                          Icon(_cityManagerExpanded
                              ? Icons.expand_less
                              : Icons.expand_more),
                        ],
                      ),
                    ),
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    child: _cityManagerExpanded
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            child: Column(
                              children: [
                                const SizedBox(height: 8),
                                _cityLoading
                                    ? const Center(
                                        child: CircularProgressIndicator())
                                    : _cities.isEmpty
                                        ? const Center(child: Text('暂无已添加城市'))
                                        : ListView.separated(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: _cities.length,
                                            separatorBuilder: (_, __) =>
                                                const Divider(height: 1),
                                            itemBuilder: (context, index) {
                                              final city = _cities[index];
                                              final isMain =
                                                  index == _mainCityIndex;
                                              return ListTile(
                                                leading: Icon(
                                                  isMain
                                                      ? Icons.star
                                                      : Icons.location_city,
                                                  color: isMain
                                                      ? Colors.amber
                                                      : null,
                                                ),
                                                title: Text(city.name),
                                                subtitle: Text(
                                                  city.admin != null &&
                                                          city.admin!.isNotEmpty
                                                      ? '${city.admin} · ${city.country}'
                                                      : city.country,
                                                ),
                                                trailing: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    if (!isMain)
                                                      IconButton(
                                                        icon: const Icon(
                                                            Icons.star_border),
                                                        tooltip: '设为主城市',
                                                        onPressed: () =>
                                                            _setMainCity(index),
                                                      ),
                                                    IconButton(
                                                      icon: const Icon(
                                                          Icons.delete_outline),
                                                      tooltip: '删除',
                                                      onPressed: isMain &&
                                                              _cities.length ==
                                                                  1
                                                          ? null
                                                          : () async {
                                                              final confirm =
                                                                  await showDialog<
                                                                      bool>(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) =>
                                                                        AlertDialog(
                                                                  title:
                                                                      const Text(
                                                                          '确认删除'),
                                                                  content: Text(
                                                                      '确定要删除 " ${city.name} " 吗？'),
                                                                  actions: [
                                                                    TextButton(
                                                                      onPressed:
                                                                          () =>
                                                                              Navigator.of(context).pop(false),
                                                                      child: const Text(
                                                                          '取消'),
                                                                    ),
                                                                    FilledButton(
                                                                      onPressed:
                                                                          () =>
                                                                              Navigator.of(context).pop(true),
                                                                      child: const Text(
                                                                          '删除'),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                              if (confirm ==
                                                                  true) {
                                                                _removeCity(
                                                                    index);
                                                              }
                                                            },
                                                    ),
                                                  ],
                                                ),
                                                onTap: !isMain
                                                    ? () => _setMainCity(index)
                                                    : null,
                                              );
                                            },
                                          ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: AppConstants.appName,
                    applicationVersion: AppConstants.appVersion,
                    applicationLegalese: AppConstants.appDescription,
                  );
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline,
                          color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 8),
                      Text('关于', style: textTheme.titleMedium),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
