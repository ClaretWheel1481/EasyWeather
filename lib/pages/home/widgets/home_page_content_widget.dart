import 'package:zephyr/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../../core/models/city.dart';
import '../../../core/models/weather.dart';
import '../../../core/models/weather_warning.dart';
import 'weather_view.dart';

class HomePageContentWidget extends StatelessWidget {
  final City city;
  final WeatherData? weather;
  final bool loading;
  final Future<void> Function() onRefresh;
  final List<WeatherWarning> warnings;

  const HomePageContentWidget({
    super.key,
    required this.city,
    required this.weather,
    required this.loading,
    required this.onRefresh,
    this.warnings = const [],
  });

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    } else if (weather == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context).weatherDataError,
            ),
            FilledButton(
              onPressed: onRefresh,
              child: Text(AppLocalizations.of(context).retry),
            ),
          ],
        ),
      );
    } else {
      return Stack(
        children: [
          RefreshIndicator(
            displacement: kToolbarHeight + 75,
            onRefresh: onRefresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: kToolbarHeight + 55),
                  WeatherView(
                    city: city,
                    weather: weather!,
                    warnings: warnings,
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
