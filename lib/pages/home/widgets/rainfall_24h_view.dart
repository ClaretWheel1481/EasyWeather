import 'package:zephyr/l10n/generated/app_localizations.dart';
import 'package:zephyr/pages/home/widgets/section_title.dart';
import 'package:flutter/material.dart';
import '../../../core/models/weather.dart';
import 'package:fl_chart/fl_chart.dart';

class Rainfall24hView extends StatelessWidget {
  final List<HourlyWeather> hourly;
  const Rainfall24hView({super.key, required this.hourly});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final now = DateTime.now();
    int startIdx = 0;
    for (int i = 0; i < hourly.length; i++) {
      final t = DateTime.tryParse(hourly[i].time);
      if (t != null &&
          (t.isAfter(now) ||
              t.hour == now.hour &&
                  t.day == now.day &&
                  t.month == now.month &&
                  t.year == now.year)) {
        startIdx = i;
        break;
      }
    }
    final endIdx =
        (startIdx + 24) <= hourly.length ? (startIdx + 24) : hourly.length;
    final hours = hourly.sublist(startIdx, endIdx);
    const double hourWidth = 70;
    final double totalWidth = hourWidth * hours.length;
    final rainfall = hours.map((h) => h.precipitation ?? 0).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SectionTitle(AppLocalizations.of(context).precipitation),
            Text(' (mm)', style: textTheme.titleSmall),
          ],
        ),
        const SizedBox(height: 8),
        Material(
          elevation: 3,
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            height: 220,
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: totalWidth,
                height: 90,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 15,
                      bottom: 30,
                      child: LineChart(
                        LineChartData(
                          minX: 0,
                          maxX: rainfall.length.toDouble(),
                          minY: (rainfall.isNotEmpty
                              ? -(rainfall.reduce((a, b) => a > b ? a : b) *
                                  0.2)
                              : -0.2),
                          maxY: (rainfall.isNotEmpty
                              ? (rainfall.reduce((a, b) => a > b ? a : b) * 1.2)
                              : 1.0),
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: [
                                if (rainfall.isNotEmpty)
                                  FlSpot(0, rainfall.first),
                                for (int i = 0; i < rainfall.length; i++)
                                  FlSpot(i + 0.5, rainfall[i]),
                                if (rainfall.isNotEmpty)
                                  FlSpot(rainfall.length.toDouble(),
                                      rainfall.last / 1.5),
                              ],
                              isCurved: true,
                              color: colorScheme.primary,
                              barWidth: 2,
                              dotData: FlDotData(show: false),
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  colors: [
                                    colorScheme.primary.withValues(alpha: 0.18),
                                    colorScheme.primary.withValues(alpha: 0.02),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                              preventCurveOverShooting: true,
                              isStrokeCapRound: true,
                            ),
                          ],
                          lineTouchData: LineTouchData(enabled: false),
                          clipData: FlClipData.all(),
                        ),
                      ),
                    ),
                    // 数值和时间
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (int i = 0; i < hours.length; i++)
                          SizedBox(
                            width: hourWidth,
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: colorScheme.primary
                                        .withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    hours[i].precipitation != null
                                        ? hours[i]
                                            .precipitation!
                                            .toStringAsFixed(1)
                                        : '-',
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  (() {
                                    final t = DateTime.tryParse(hours[i].time);
                                    return t != null
                                        ? '${t.hour.toString().padLeft(2, '0')}:00'
                                        : '';
                                  })(),
                                  style: textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant
                                        .withValues(alpha: 0.7),
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 6),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
