import 'package:flutter/material.dart';
import 'package:zephyr/core/models/weather.dart';
import 'package:zephyr/core/utils/weather_utils.dart';
import 'package:zephyr/l10n/generated/app_localizations.dart';
import 'package:percent_indicator/percent_indicator.dart';

class AirQualityCard extends StatelessWidget {
  final CurrentWeather current;
  const AirQualityCard({super.key, required this.current});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final aqiColor = getAqiColor('aqi', current.euAQI ?? 0, colorScheme);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color: colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 10, 24, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context).airQuality,
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.info_outline),
                  color: colorScheme.onPrimaryContainer,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(AppLocalizations.of(context).eAQIGrading),
                        content: Text(
                          AppLocalizations.of(context).eAQIDesc,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(MaterialLocalizations.of(context)
                                .okButtonLabel),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                CircularPercentIndicator(
                  radius: 48,
                  lineWidth: 12,
                  percent: ((current.euAQI ?? 0) / 100).clamp(0.0, 1.0),
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(current.euAQI?.toStringAsFixed(0) ?? '--',
                          style:
                              textTheme.titleLarge?.copyWith(color: aqiColor)),
                      Text('AQI', style: textTheme.bodySmall),
                    ],
                  ),
                  progressColor: aqiColor,
                  backgroundColor: colorScheme.outline.withAlpha(30),
                  circularStrokeCap: CircularStrokeCap.round,
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPollutantBar(context, 'PM2.5', current.pm25,
                          'pm2_5', 'μg/m³', colorScheme),
                      _buildPollutantBar(context, 'PM10', current.pm10, 'pm10',
                          'μg/m³', colorScheme),
                      _buildPollutantBar(context, 'O₃', current.ozone, 'o3',
                          'μg/m³', colorScheme),
                      _buildPollutantBar(context, 'NO₂',
                          current.nitrogenDioxide, 'no2', 'μg/m³', colorScheme),
                      _buildPollutantBar(context, 'SO₂', current.sulphurDioxide,
                          'so2', 'μg/m³', colorScheme),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 单项污染物的柱状图
  Widget _buildPollutantBar(BuildContext context, String label, double? value,
      String type, String unit, ColorScheme colorScheme) {
    final max = getAqiMaxValue(type);
    final color = getAqiColor(type, value ?? 0, colorScheme);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
              width: 48,
              child: Text(label, style: Theme.of(context).textTheme.bodySmall)),
          Expanded(
            child: LinearProgressIndicator(
              value: ((value ?? 0) / max).clamp(0.0, 1.0),
              color: color,
              backgroundColor: colorScheme.outline.withAlpha(30),
              minHeight: 10,
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 70,
            child: Text(
              value != null ? '${value.toStringAsFixed(1)} $unit' : '--',
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
