import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zephyr/pages/settings/widgets/request_homewidget_widget.dart';
import 'package:zephyr/pages/settings/widgets/ignore_battery_optimization_widget.dart';
import '../../core/models/city.dart';
import '../../core/notifiers.dart';
import '../../l10n/generated/app_localizations.dart';
import 'widgets/city_manager_widget.dart';
import 'widgets/temp_unit_selector_widget.dart';
import 'widgets/theme_mode_selector_widget.dart';
import 'widgets/about_app_widget.dart';
import 'widgets/language_selector_widget.dart';

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

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadCities();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _themeMode = ThemeMode.values[prefs.getInt('theme_mode') ?? 0];
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
    final city = _cities[index];
    final l10n = AppLocalizations.of(context);

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(MaterialLocalizations.of(context).okButtonLabel),
        content: Text(l10n.deleteCityMessage(city.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (!mounted) return;

    if (confirm == true) {
      setState(() {
        _cities.removeAt(index);
        if (_mainCityIndex >= _cities.length) {
          _mainCityIndex = 0;
        }
      });
      await _saveCities();
    }
  }

  void _setMainCity(int index) async {
    setState(() {
      _mainCityIndex = index;
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
    final l10n = AppLocalizations.of(context);

    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.settings)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.topLeft,
          child: Text(l10n.settings),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 城市管理
          CityManagerWidget(
            cities: _cities,
            mainCityIndex: _mainCityIndex,
            cityLoading: _cityLoading,
            cityManagerExpanded: _cityManagerExpanded,
            onSetMainCity: _setMainCity,
            onRemoveCity: _removeCity,
            onToggleExpand: () {
              setState(() {
                _cityManagerExpanded = !_cityManagerExpanded;
              });
            },
          ),
          const SizedBox(height: 16),
          // 温度单位
          TempUnitSelectorWidget(
            tempUnit: _tempUnit,
            onTempUnitChanged: _saveTempUnit,
          ),
          const SizedBox(height: 16),
          // 主题模式 + Monet取色
          ThemeModeSelectorWidget(
            themeMode: _themeMode,
            dynamicColorEnabled: _dynamicColorEnabled,
            onThemeModeChanged: _saveThemeMode,
            onDynamicColorChanged: _saveDynamicColorEnabled,
          ),
          const SizedBox(height: 16),
          // 语言选择
          const LanguageSelectorWidget(),
          const SizedBox(height: 16),
          const RequestHomewidgetWidget(),
          const SizedBox(height: 16),
          const IgnoreBatteryOptimizationWidget(),
          const SizedBox(height: 16),
          // 关于
          const AboutAppWidget(),
        ],
      ),
    );
  }
}
