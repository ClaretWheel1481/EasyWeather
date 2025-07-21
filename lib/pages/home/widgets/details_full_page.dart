import 'package:flutter/material.dart';
import 'package:zephyr/l10n/generated/app_localizations.dart';
import '../../../core/models/weather.dart';
import 'package:fl_chart/fl_chart.dart';

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
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).detailedData),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
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
                          AppLocalizations.of(context).hourly_windSpeed,
                          style: textTheme.titleMedium?.copyWith(
                            color: colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.info_outline),
                          color: colorScheme.onPrimaryContainer,
                          tooltip:
                              AppLocalizations.of(context).hourly_windSpeed,
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(AppLocalizations.of(context)
                                    .hourly_windSpeed),
                                content: Text(AppLocalizations.of(context)
                                    .hourly_windSpeed_Desc),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text(
                                        MaterialLocalizations.of(context)
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
                      child: WindLineChart(hourly: hourly!),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
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
                                title: Text(AppLocalizations.of(context)
                                    .hourly_pressure),
                                content: Text(AppLocalizations.of(context)
                                    .hourly_pressure_Desc),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text(
                                        MaterialLocalizations.of(context)
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
                      child: PressureLineChart(hourly: hourly!),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WindLineChart extends StatelessWidget {
  final List<HourlyWeather> hourly;
  const WindLineChart({super.key, required this.hourly});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    // 取前24小时
    final hours = hourly.length > 24 ? hourly.sublist(0, 24) : hourly;
    List<FlSpot> spots10m = [];
    List<FlSpot> spots80m = [];
    List<FlSpot> spots120m = [];
    for (int i = 0; i < hours.length; i++) {
      spots10m.add(FlSpot(i.toDouble(), hours[i].windSpeed10m ?? 0));
      spots80m.add(FlSpot(i.toDouble(), hours[i].windSpeed80m ?? 0));
      spots120m.add(FlSpot(i.toDouble(), hours[i].windSpeed120m ?? 0));
    }
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true, drawVerticalLine: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 40),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 3,
              getTitlesWidget: (value, meta) {
                int idx = value.toInt();
                if (idx < 0 || idx >= hours.length) return const SizedBox();
                final t = hours[idx].time;
                return Text(t.substring(11, 13), style: textTheme.bodySmall);
              },
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: colorScheme.outline.withAlpha(60)),
        ),
        minY: 0,
        lineBarsData: [
          LineChartBarData(
            spots: spots10m,
            isCurved: true,
            color: colorScheme.primary,
            barWidth: 3,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
          LineChartBarData(
            spots: spots80m,
            isCurved: true,
            color: colorScheme.secondary,
            barWidth: 3,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
          LineChartBarData(
            spots: spots120m,
            isCurved: true,
            color: colorScheme.tertiary,
            barWidth: 3,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: colorScheme.surface,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                String label = '';
                if (spot.barIndex == 0) label = '10m';
                if (spot.barIndex == 1) label = '80m';
                if (spot.barIndex == 2) label = '120m';
                return LineTooltipItem(
                  '$label: ${spot.y.toStringAsFixed(1)} km/h',
                  textTheme.bodySmall!.copyWith(
                    color: colorScheme.onSurface,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}

class PressureLineChart extends StatelessWidget {
  final List<HourlyWeather> hourly;
  const PressureLineChart({super.key, required this.hourly});

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
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true, drawVerticalLine: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: 10,
              getTitlesWidget: (value, meta) {
                if (value % 10 == 0 && value >= 970 && value <= 1050) {
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
                if (idx < 0 || idx >= hours.length) return const SizedBox();
                final t = hours[idx].time;
                return Text(t.substring(11, 13), style: textTheme.bodySmall);
              },
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: colorScheme.outline.withAlpha(60)),
        ),
        minY: 970,
        maxY: 1050,
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
            tooltipBgColor: colorScheme.surface,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                String label = '';
                if (spot.barIndex == 0) label = 'SeaLevel';
                if (spot.barIndex == 1) label = 'Surface';
                return LineTooltipItem(
                  '$label: ${spot.y.toStringAsFixed(1)} hPa',
                  textTheme.bodySmall!.copyWith(
                    color: colorScheme.onSurface,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}
