import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:zephyr/core/models/weather.dart';
import 'package:zephyr/l10n/generated/app_localizations.dart';

class PressureLineChartCard extends StatelessWidget {
  final List<HourlyWeather> hourly;
  const PressureLineChartCard({super.key, required this.hourly});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final hours = hourly.length > 24 ? hourly.sublist(0, 24) : hourly;
    List<FlSpot> spotsSeaLevel = [];
    List<FlSpot> spotsSurface = [];
    for (int i = 0; i < hours.length; i++) {
      spotsSeaLevel.add(FlSpot(i.toDouble(), hours[i].pressureMsl ?? 0));
      spotsSurface.add(FlSpot(i.toDouble(), hours[i].surfacePressure ?? 0));
    }
    final allPressures = [
      ...spotsSeaLevel.map((e) => e.y),
      ...spotsSurface.map((e) => e.y),
    ];
    double minPressure = allPressures.isNotEmpty
        ? allPressures.reduce((a, b) => a < b ? a : b)
        : 970;
    double maxPressure = allPressures.isNotEmpty
        ? allPressures.reduce((a, b) => a > b ? a : b)
        : 1050;
    double minY = (minPressure - 10).clamp(600, 1100);
    double maxY = (maxPressure + 10).clamp(600, 1100);
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
                  AppLocalizations.of(context).hourly_pressure,
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
                        title:
                            Text(AppLocalizations.of(context).hourly_pressure),
                        content: Text(
                            AppLocalizations.of(context).hourly_pressure_Desc),
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
            SizedBox(
              height: 260,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true, drawVerticalLine: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval: 10,
                        getTitlesWidget: (value, meta) {
                          if (value % 10 == 0 &&
                              value >= minY &&
                              value <= maxY) {
                            return Text(value.toInt().toString(),
                                style: textTheme.bodySmall);
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 3,
                        getTitlesWidget: (value, meta) {
                          int idx = value.toInt();
                          if (idx < 0 || idx >= hours.length)
                            return const SizedBox();
                          final t = hours[idx].time;
                          return Text(t.substring(11, 13),
                              style: textTheme.bodySmall);
                        },
                      ),
                    ),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border:
                        Border.all(color: colorScheme.outline.withAlpha(60)),
                  ),
                  minY: minY,
                  maxY: maxY,
                  lineBarsData: [
                    LineChartBarData(
                      spots: spotsSeaLevel,
                      isCurved: true,
                      color: colorScheme.primary,
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                    LineChartBarData(
                      spots: spotsSurface,
                      isCurved: true,
                      color: colorScheme.secondary,
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          String label = '';
                          if (spot.barIndex == 0) label = 'SeaLevel';
                          if (spot.barIndex == 1) label = 'Surface';
                          return LineTooltipItem(
                            '$label:  {spot.y.toStringAsFixed(1)} hPa',
                            textTheme.bodySmall!.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
