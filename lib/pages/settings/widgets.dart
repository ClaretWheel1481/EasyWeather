import 'package:easyweather/services/update.dart';
import 'package:flutter/material.dart';

AboutDialog buildAboutDialog() {
  return AboutDialog(
    applicationVersion: currentVersion,
    applicationName: 'EasyWeather',
    applicationLegalese: "Copyright© 2024 Lance Huang",
  );
}
