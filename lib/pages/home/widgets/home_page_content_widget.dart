import 'package:easyweather/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../../core/models/city.dart';
import '../../../core/models/weather.dart';
import 'weather_bg.dart';
import 'weather_view.dart';

class HomePageContentWidget extends StatelessWidget {
  final City city;
  final WeatherData? weather;
  final bool loading;
  final Future<void> Function() onRefresh;

  const HomePageContentWidget({
    super.key,
    required this.city,
    required this.weather,
    required this.loading,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    } else if (weather == null) {
      return Center(
        child: Text(AppLocalizations.of(context).weatherDataError,
            style: TextStyle(color: Colors.white)),
      );
    } else {
      return Stack(
        children: [
          WeatherBg(weatherCode: weather!.current?.weatherCode),
          if (Theme.of(context).brightness == Brightness.dark)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.black.withValues(alpha: 0.3),
              ),
            ),
          RefreshIndicator(
            displacement: kToolbarHeight + 45,
            onRefresh: onRefresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: kToolbarHeight + 35),
                  WeatherView(
                    city: city,
                    weather: weather!,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }
  }
}
