import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:zephyr/core/models/weather.dart';
import 'package:zephyr/l10n/generated/app_localizations.dart';

class WindLineChartCard extends StatelessWidget {
  final List<HourlyWeather> hourly;
  const WindLineChartCard({super.key, required this.hourly});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final hours = hourly.length > 24 ? hourly.sublist(0, 24) : hourly;
    List<FlSpot> spots10m = [];
    List<FlSpot> spots80m = [];
    List<FlSpot> spots120m = [];
    for (int i = 0; i < hours.length; i++) {
      spots10m.add(FlSpot(i.toDouble(), hours[i].windSpeed10m ?? 0));
      spots80m.add(FlSpot(i.toDouble(), hours[i].windSpeed80m ?? 0));
      spots120m.add(FlSpot(i.toDouble(), hours[i].windSpeed120m ?? 0));
    }
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
                  AppLocalizations.of(context).hourly_windSpeed,
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
                  tooltip: AppLocalizations.of(context).hourly_windSpeed,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title:
                            Text(AppLocalizations.of(context).hourly_windSpeed),
                        content: Text(
                            AppLocalizations.of(context).hourly_windSpeed_Desc),
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
            SizedBox(
              height: 240,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: colorScheme.outlineVariant,
                        strokeWidth: 0.5,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: colorScheme.outlineVariant,
                        strokeWidth: 0.5,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 35,
                        interval: 5,
                        getTitlesWidget: (value, meta) {
                          if (value % 10 == 0) {
                            return Text(
                              value.toInt().toString(),
                              style: textTheme.labelMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            );
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
                          if (idx < 0 || idx >= hours.length) {
                            return const SizedBox();
                          }
                          final t = hours[idx].time;
                          return Text(
                            t.substring(11, 13),
                            style: textTheme.labelMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          );
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
                    border: Border.all(
                      color: colorScheme.outlineVariant,
                      width: 0.5,
                    ),
                  ),
                  minY: 0,
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots10m,
                      isCurved: true,
                      color: colorScheme.primary,
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: colorScheme.primary.withValues(alpha: 0.2),
                      ),
                    ),
                    LineChartBarData(
                      spots: spots80m,
                      isCurved: true,
                      color: colorScheme.secondary,
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: colorScheme.secondary.withValues(alpha: 0.2),
                      ),
                    ),
                    LineChartBarData(
                      spots: spots120m,
                      isCurved: true,
                      color: colorScheme.tertiary,
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: colorScheme.tertiary.withValues(alpha: 0.2),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          String label = '';
                          if (spot.barIndex == 0) label = '10m';
                          if (spot.barIndex == 1) label = '80m';
                          if (spot.barIndex == 2) label = '120m';
                          return LineTooltipItem(
                            '$label: ${spot.y.toStringAsFixed(1)} km/h',
                            textTheme.labelMedium!.copyWith(
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
