import 'package:flutter/material.dart';
import '../../../core/notifiers.dart';
import '../../../core/utils/weather_utils.dart';

class FutureWeatherBand extends StatelessWidget {
  final List daily;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  const FutureWeatherBand(
      {required this.daily,
      required this.colorScheme,
      required this.textTheme,
      super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bandWidth = constraints.maxWidth;
        final bandHeight = constraints.maxHeight;
        final itemCount = daily.length;
        final barWidth = bandWidth / (itemCount * 1.2);
        double minTemp = double.infinity, maxTemp = -double.infinity;
        for (var d in daily) {
          final tmax = d.tempMax ?? 0;
          final tmin = d.tempMin ?? 0;
          if (tmax > maxTemp) maxTemp = tmax;
          if (tmin < minTemp) minTemp = tmin;
        }
        final tempRange =
            (maxTemp - minTemp).abs() < 1e-3 ? 1.0 : (maxTemp - minTemp);
        List<_TempBar> bars = [];
        for (int i = 0; i < itemCount; i++) {
          final d = daily[i];
          final tmax = d.tempMax ?? 0;
          final tmin = d.tempMin ?? 0;
          final x = (i + 0.5) * barWidth * 1.2;
          final yMax = bandHeight * 0.1;
          final yMin = bandHeight * 0.55;
          final yTop = yMax + (yMin - yMax) * (maxTemp - tmax) / tempRange;
          final yBottom = yMax + (yMin - yMax) * (maxTemp - tmin) / tempRange;
          bars.add(_TempBar(
            x: x,
            yTop: yTop,
            yBottom: yBottom,
            tmax: tmax,
            tmin: tmin,
            date: d.date,
            weatherCode: d.weatherCode,
            weatherDesc: weatherDesc(d.weatherCode),
          ));
        }
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: bars
                  .map((bar) => Expanded(
                        child: Column(
                          children: [
                            Text(
                              bar.date.substring(5),
                              style: textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 2),
                            Icon(weatherIcon(bar.weatherCode),
                                color: colorScheme.primary, size: 24),
                          ],
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: bars.map((bar) {
                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: bar.yTop),
                        ValueListenableBuilder<String>(
                          valueListenable: tempUnitNotifier,
                          builder: (context, unit, _) => Text(
                            '${bar.tmax.toStringAsFixed(1)}°$unit',
                            style: textTheme.bodySmall
                                ?.copyWith(color: colorScheme.error),
                          ),
                        ),
                        Container(
                          width: 10,
                          height: (bar.yBottom - bar.yTop).abs().clamp(18, 60),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            gradient: LinearGradient(
                              colors: [
                                colorScheme.primary.withValues(alpha: 0.8),
                                colorScheme.primary.withValues(alpha: 0.15)
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                        ValueListenableBuilder<String>(
                          valueListenable: tempUnitNotifier,
                          builder: (context, unit, _) => Text(
                            '${bar.tmin.toStringAsFixed(1)}°$unit',
                            style: textTheme.bodySmall
                                ?.copyWith(color: colorScheme.primary),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TempBar {
  final double x;
  final double yTop;
  final double yBottom;
  final double tmax;
  final double tmin;
  final String date;
  final int? weatherCode;
  final String weatherDesc;
  _TempBar(
      {required this.x,
      required this.yTop,
      required this.yBottom,
      required this.tmax,
      required this.tmin,
      required this.date,
      required this.weatherCode,
      required this.weatherDesc});
}
