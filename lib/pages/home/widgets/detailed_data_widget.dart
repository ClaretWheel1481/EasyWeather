import 'package:flutter/material.dart';
import 'package:easyweather/l10n/generated/app_localizations.dart';
import '../../../core/models/weather.dart';

class DetailedDataWidget extends StatelessWidget {
  final CurrentWeather? current;
  final DailyWeather? daily;

  const DetailedDataWidget({
    super.key,
    required this.current,
    required this.daily,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          color: colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    // 风速
                    Expanded(
                      child: _buildDataTile(
                        context,
                        icon: Icons.air,
                        label: AppLocalizations.of(context).windSpeed,
                        value: current?.windSpeed != null
                            ? current!.windSpeed.toStringAsFixed(1)
                            : '-',
                        unit: 'm/s',
                      ),
                    ),
                    const SizedBox(width: 12),
                    // 气压
                    Expanded(
                      child: _buildDataTile(
                        context,
                        icon: Icons.insights,
                        label: AppLocalizations.of(context).surfacePressure,
                        value: current?.surfacePressure != null
                            ? current!.surfacePressure!.toStringAsFixed(1)
                            : '-',
                        unit: 'hPa',
                      ),
                    ),
                    const SizedBox(width: 12),
                    // 紫外线指数
                    Expanded(
                      child: _buildDataTile(
                        context,
                        icon: Icons.sunny,
                        label: AppLocalizations.of(context).uvIndex,
                        value: daily?.uvIndexMax != null
                            ? daily!.uvIndexMax!.toStringAsFixed(1)
                            : '-',
                        unit: 'UV',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDataTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required String unit,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.onInverseSurface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: colorScheme.primary,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          if (unit.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              unit,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
