import 'package:easyweather/constants/app_constants.dart';
import 'package:flutter/material.dart';

AboutDialog buildAboutDialog() {
  return AboutDialog(
    applicationVersion: AppConstants.currentVersion,
    applicationName: 'EasyWeather',
    applicationLegalese: "Copyright© 2024 Lance Huang",
  );
}
