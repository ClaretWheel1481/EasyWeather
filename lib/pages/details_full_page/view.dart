import 'package:flutter/material.dart';
import 'package:zephyr/l10n/generated/app_localizations.dart';
import '../../core/models/weather.dart';
import 'widgets/air_quality_widget.dart';
import 'widgets/wind_line_chart.dart';
import 'widgets/pressure_line_chart.dart';

class DetailedDataFullPage extends StatelessWidget {
  final CurrentWeather? current;
  final DailyWeather? daily;
  final List<HourlyWeather>? hourly;

  const DetailedDataFullPage({
    super.key,
    required this.current,
    required this.daily,
    required this.hourly,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).detailedData),
        backgroundColor: colorScheme.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (current != null && current!.euAQI != null) ...[
              AirQualityCard(current: current!),
              const SizedBox(height: 12),
            ],
            if (hourly != null && hourly!.isNotEmpty) ...[
              WindLineChartCard(hourly: hourly!),
              const SizedBox(height: 12),
              PressureLineChartCard(hourly: hourly!),
            ],
          ],
        ),
      ),
    );
  }
}
