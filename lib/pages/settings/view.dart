import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<Settings> {
  String _themeMode = 'system';

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _themeMode = prefs.getString('themeMode') ?? 'system';
    });
  }

  Future<void> _saveThemeMode(String themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', themeMode);
    setState(() {
      _themeMode = themeMode;
    });
  }

  void _changeThemeMode(String themeMode) {
    _saveThemeMode(themeMode);
    if (themeMode == 'light') {
      Get.changeThemeMode(ThemeMode.light);
    } else if (themeMode == 'dark') {
      Get.changeThemeMode(ThemeMode.dark);
    } else {
      Get.changeThemeMode(ThemeMode.system);
    }
  }

  AboutDialog _buildAboutDialog() {
    return const AboutDialog(
      applicationVersion: 'v1.1.3',
      applicationName: 'EasyWeather',
      applicationLegalese: "Copyright© 2024 Lance Huang",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: ListView(
        children: [
          ExpansionTile(
            leading: const Icon(Icons.light_mode),
            title: const Text('主题'),
            children: [
              RadioListTile<String>(
                title: const Text('浅色'),
                value: 'light',
                groupValue: _themeMode,
                onChanged: (value) {
                  if (value != null) {
                    _changeThemeMode(value);
                  }
                },
              ),
              RadioListTile<String>(
                title: const Text('深色'),
                value: 'dark',
                groupValue: _themeMode,
                onChanged: (value) {
                  if (value != null) {
                    _changeThemeMode(value);
                  }
                },
              ),
              RadioListTile<String>(
                title: const Text('跟随系统设置'),
                value: 'system',
                groupValue: _themeMode,
                onChanged: (value) {
                  if (value != null) {
                    _changeThemeMode(value);
                  }
                },
              ),
            ],
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('关于'),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return _buildAboutDialog();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
