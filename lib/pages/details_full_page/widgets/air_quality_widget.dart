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
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
        side: BorderSide(
          color: colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      color: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context).airQuality,
                  style: textTheme.titleLarge?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.info_outline,
                    color: colorScheme.onSurfaceVariant,
                  ),
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
                            child: Text(
                              MaterialLocalizations.of(context).okButtonLabel,
                              style: TextStyle(
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircularPercentIndicator(
                  radius: 46,
                  lineWidth: 10,
                  percent: ((current.euAQI ?? 0) / 100).clamp(0.0, 1.0),
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        current.euAQI?.toStringAsFixed(0) ?? '--',
                        style: textTheme.titleMedium?.copyWith(
                          color: aqiColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'AQI',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  progressColor: aqiColor,
                  backgroundColor: colorScheme.outlineVariant,
                  circularStrokeCap: CircularStrokeCap.round,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPollutantBar(context, 'PM2.5', current.pm25,
                          'pm2_5', 'μg/m³', colorScheme),
                      const SizedBox(height: 12),
                      _buildPollutantBar(context, 'PM10', current.pm10, 'pm10',
                          'μg/m³', colorScheme),
                      const SizedBox(height: 12),
                      _buildPollutantBar(context, 'O₃', current.ozone, 'o3',
                          'μg/m³', colorScheme),
                      const SizedBox(height: 12),
                      _buildPollutantBar(context, 'NO₂',
                          current.nitrogenDioxide, 'no2', 'μg/m³', colorScheme),
                      const SizedBox(height: 12),
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
    return Row(
      children: [
        SizedBox(
          width: 48,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface,
                ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LinearProgressIndicator(
                value: ((value ?? 0) / max).clamp(0.0, 1.0),
                color: color,
                backgroundColor: colorScheme.outlineVariant,
                minHeight: 10,
                borderRadius: BorderRadius.circular(5),
              ),
              const SizedBox(height: 2),
              Text(
                value != null ? '${value.toStringAsFixed(1)} $unit' : '--',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
