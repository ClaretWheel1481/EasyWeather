import 'package:flutter/material.dart';
import 'package:zephyr/l10n/generated/app_localizations.dart';
import '../../../core/models/weather.dart';
import 'package:animations/animations.dart';
import '../../details_full_page/view.dart';

class DetailedDataWidget extends StatelessWidget {
  final CurrentWeather? current;
  final DailyWeather? daily;
  final List<HourlyWeather>? hourly;

  const DetailedDataWidget({
    super.key,
    required this.current,
    required this.daily,
    required this.hourly,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: OpenContainer(
        transitionType: ContainerTransitionType.fadeThrough,
        closedElevation: 3,
        closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        closedColor: colorScheme.surface,
        openColor: colorScheme.surface,
        closedBuilder: (context, openContainer) {
          return GestureDetector(
            onTap: openContainer,
            child: _buildCard(context, colorScheme),
          );
        },
        openBuilder: (context, _) => DetailedDataFullPage(
          current: current,
          daily: daily,
          hourly: hourly,
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, ColorScheme colorScheme) {
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
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  children: [
                    // PM2.5
                    Expanded(
                      child: DataTile(
                        icon: Icons.air,
                        label: "PM2.5",
                        value: current?.pm25 != null
                            ? current!.pm25!.toStringAsFixed(1)
                            : '-',
                        unit: 'μg/m³',
                      ),
                    ),
                    const SizedBox(width: 12),
                    // PM10
                    Expanded(
                      child: DataTile(
                        icon: Icons.air,
                        label: "PM10",
                        value: current?.pm10 != null
                            ? current!.pm10!.toStringAsFixed(1)
                            : '-',
                        unit: 'μg/m³',
                      ),
                    ),
                    const SizedBox(width: 12),
                    // 紫外线指数
                    Expanded(
                      child: DataTile(
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
                const SizedBox(height: 12),
                Row(
                  children: [
                    // 风速
                    Expanded(
                      child: DataTile(
                        icon: Icons.waves,
                        label: AppLocalizations.of(context).windSpeed,
                        value: current?.windSpeed != null
                            ? current!.windSpeed.toStringAsFixed(1)
                            : '-',
                        unit: 'm/s',
                      ),
                    ),
                    const SizedBox(width: 12),
                    // 能见度
                    Expanded(
                      child: DataTile(
                        icon: Icons.remove_red_eye,
                        label: AppLocalizations.of(context).visibility,
                        value: (hourly != null &&
                                hourly!.isNotEmpty &&
                                hourly!.first.visibility != null)
                            ? (hourly!.first.visibility! / 1000)
                                .toStringAsFixed(1)
                            : '-',
                        unit: 'km',
                      ),
                    ),
                    const SizedBox(width: 12),
                    // 气压
                    Expanded(
                      child: DataTile(
                        icon: Icons.insights,
                        label: AppLocalizations.of(context).pressure,
                        value: current?.surfacePressure != null
                            ? current!.surfacePressure!.toStringAsFixed(1)
                            : '-',
                        unit: 'hPa',
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
}

class DataTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String unit;

  const DataTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.onInverseSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: colorScheme.primary, size: 24),
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
