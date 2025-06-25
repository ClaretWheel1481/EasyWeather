import 'package:flutter/material.dart';
import '../core/models/city.dart';
import '../core/models/weather.dart';
import '../core/utils/weather_utils.dart';
import '../core/notifiers.dart';

class WeatherView extends StatelessWidget {
  final City city;
  final WeatherData weather;
  const WeatherView({super.key, required this.city, required this.weather});

  @override
  Widget build(BuildContext context) {
    final current = weather.current;
    final daily = weather.daily;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 顶部天气卡片
          if (current != null)
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              color: colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Icon(weatherIcon(current.weatherCode),
                        size: 72, color: colorScheme.primary),
                    const SizedBox(height: 8),
                    ValueListenableBuilder<String>(
                      valueListenable: tempUnitNotifier,
                      builder: (context, unit, _) => Text(
                        '${current.temperature}°$unit',
                        style: textTheme.displayLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(weatherDesc(current.weatherCode),
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                        )),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        WeatherInfoTile(
                          icon: Icons.thermostat,
                          label: '体感',
                          value: current.apparentTemperature != null
                              ? current.apparentTemperature!.toStringAsFixed(1)
                              : '-',
                          unit: '°${tempUnitNotifier.value}',
                        ),
                        WeatherInfoTile(
                          icon: Icons.water_drop,
                          label: '湿度',
                          value: current.humidity != null
                              ? current.humidity!.toStringAsFixed(0)
                              : '-',
                          unit: '%',
                        ),
                        WeatherInfoTile(
                          icon: Icons.air,
                          label: '风速',
                          value: current.windSpeed.toStringAsFixed(1),
                          unit: 'm/s',
                        ),
                        WeatherInfoTile(
                          icon: Icons.navigation,
                          label: '风向',
                          value: current.windDirection != null
                              ? windDirectionText(current.windDirection!)
                              : '-',
                          unit: '',
                        ),
                        WeatherInfoTile(
                          icon: Icons.remove_red_eye,
                          label: '能见度',
                          value: current.visibility != null
                              ? (current.visibility! / 1000).toStringAsFixed(1)
                              : '-',
                          unit: 'km',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 20),
          // 24小时天气
          SectionTitle('24小时天气'),
          const SizedBox(height: 8),
          if (weather.hourly.isNotEmpty)
            Builder(
              builder: (context) {
                final now = DateTime.now();
                int startIdx = 0;
                for (int i = 0; i < weather.hourly.length; i++) {
                  final t = DateTime.tryParse(weather.hourly[i].time);
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
                final endIdx = (startIdx + 24) <= weather.hourly.length
                    ? (startIdx + 24)
                    : weather.hourly.length;
                final hours = weather.hourly.sublist(startIdx, endIdx);
                return SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: hours.length,
                    itemBuilder: (context, i) {
                      final h = hours[i];
                      final t = DateTime.tryParse(h.time);
                      final hourStr = t != null
                          ? '${t.hour.toString().padLeft(2, '0')}:00'
                          : '';
                      final isNow = i == 0;
                      return Container(
                        width: 80,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color:
                              isNow ? colorScheme.primary : colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: isNow
                              ? Border.all(color: colorScheme.primary, width: 2)
                              : null,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(hourStr,
                                style: textTheme.bodyMedium?.copyWith(
                                    color: isNow
                                        ? colorScheme.onPrimary
                                        : colorScheme.onSurfaceVariant)),
                            const SizedBox(height: 4),
                            Icon(weatherIcon(h.weatherCode),
                                color: isNow
                                    ? colorScheme.onPrimary
                                    : colorScheme.primary,
                                size: 28),
                            const SizedBox(height: 4),
                            ValueListenableBuilder<String>(
                              valueListenable: tempUnitNotifier,
                              builder: (context, unit, _) => Text(
                                h.temperature != null
                                    ? '${h.temperature!.toStringAsFixed(1)}°$unit'
                                    : '-',
                                style: textTheme.titleMedium?.copyWith(
                                  color: isNow
                                      ? colorScheme.onPrimary
                                      : colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          const SizedBox(height: 24),
          // 24小时降雨量
          Rainfall24hView(hourly: weather.hourly),
          const SizedBox(height: 24),
          // 未来天气
          SectionTitle('未来天气'),
          const SizedBox(height: 8),
          if (daily.isNotEmpty)
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              color: colorScheme.surface,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                child: SizedBox(
                  height: 230,
                  child: _FutureWeatherBand(
                      daily: daily,
                      colorScheme: colorScheme,
                      textTheme: textTheme),
                ),
              ),
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class WeatherInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String unit;
  const WeatherInfoTile(
      {super.key,
      required this.icon,
      required this.label,
      required this.value,
      required this.unit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 28, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 4),
        Text('$value$unit', style: Theme.of(context).textTheme.titleMedium),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle(this.title, {super.key});
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _FutureWeatherBand extends StatelessWidget {
  final List daily;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  const _FutureWeatherBand(
      {required this.daily,
      required this.colorScheme,
      required this.textTheme});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bandWidth = constraints.maxWidth;
        final bandHeight = constraints.maxHeight;
        final itemCount = daily.length;
        final barWidth = bandWidth / (itemCount * 1.2);
        // 计算全局最高温和最低温
        double minTemp = double.infinity, maxTemp = -double.infinity;
        for (var d in daily) {
          final tmax = d.tempMax ?? 0;
          final tmin = d.tempMin ?? 0;
          if (tmax > maxTemp) maxTemp = tmax;
          if (tmin < minTemp) minTemp = tmin;
        }
        final tempRange =
            (maxTemp - minTemp).abs() < 1e-3 ? 1.0 : (maxTemp - minTemp);
        // 计算每一天的温度柱坐标
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
                        // 最高温
                        ValueListenableBuilder<String>(
                          valueListenable: tempUnitNotifier,
                          builder: (context, unit, _) => Text(
                            '${bar.tmax.toStringAsFixed(1)}°$unit',
                            style: textTheme.titleSmall
                                ?.copyWith(color: colorScheme.error),
                          ),
                        ),
                        // 温度柱
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
                        // 最低温
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text('24小时降雨量',
              style:
                  textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 8),
        Container(
          height: 150,
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: totalWidth,
              height: 90,
              child: Stack(
                children: [
                  // 曲线和阴影
                  Positioned.fill(
                    child: RainfallCurveWithShadow(
                      rainfall: rainfall,
                      color: colorScheme.primary,
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
                              // 数值气泡
                              Container(
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
      ],
    );
  }
}

// 曲线+阴影
class RainfallCurveWithShadow extends StatelessWidget {
  final List<double> rainfall;
  final Color color;
  const RainfallCurveWithShadow(
      {super.key, required this.rainfall, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RainfallCurveShadowPainter(rainfall, color),
      child: CustomPaint(
        painter: RainfallCurvePainter(rainfall, color),
      ),
    );
  }
}

class RainfallCurvePainter extends CustomPainter {
  final List<double> rainfall;
  final Color color;
  RainfallCurvePainter(this.rainfall, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    if (rainfall.isEmpty) return;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final maxRain = rainfall.reduce((a, b) => a > b ? a : b);
    final minRain = rainfall.reduce((a, b) => a < b ? a : b);
    final range = (maxRain - minRain).abs() < 1e-3 ? 1.0 : (maxRain - minRain);
    // 增大曲线的上下padding，避免碰到顶部数值和底部时间
    final topPadding = size.height * 0.35;
    final bottomPadding = size.height * 0.32;
    List<Offset> points = [];
    for (int i = 0; i < rainfall.length; i++) {
      final x = i * size.width / (rainfall.length - 1);
      final y = topPadding +
          (size.height - topPadding - bottomPadding) *
              (1 - (rainfall[i] - minRain) / range);
      points.add(Offset(x, y));
    }
    // Catmull-Rom样条插值
    final path = Path();
    if (points.isNotEmpty) {
      path.moveTo(points[0].dx, points[0].dy);
      for (int i = 0; i < points.length - 1; i++) {
        final p0 = i == 0 ? points[0] : points[i - 1];
        final p1 = points[i];
        final p2 = points[i + 1];
        final p3 =
            i + 2 < points.length ? points[i + 2] : points[points.length - 1];
        for (double t = 0; t < 1; t += 0.2) {
          final tt = t * t;
          final ttt = tt * t;
          final x = 0.5 *
              ((2 * p1.dx) +
                  (-p0.dx + p2.dx) * t +
                  (2 * p0.dx - 5 * p1.dx + 4 * p2.dx - p3.dx) * tt +
                  (-p0.dx + 3 * p1.dx - 3 * p2.dx + p3.dx) * ttt);
          final y = 0.5 *
              ((2 * p1.dy) +
                  (-p0.dy + p2.dy) * t +
                  (2 * p0.dy - 5 * p1.dy + 4 * p2.dy - p3.dy) * tt +
                  (-p0.dy + 3 * p1.dy - 3 * p2.dy + p3.dy) * ttt);
          path.lineTo(x, y);
        }
        path.lineTo(p2.dx, p2.dy);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant RainfallCurvePainter oldDelegate) {
    return oldDelegate.rainfall != rainfall || oldDelegate.color != color;
  }
}

class _RainfallCurveShadowPainter extends CustomPainter {
  final List<double> rainfall;
  final Color color;
  _RainfallCurveShadowPainter(this.rainfall, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    if (rainfall.isEmpty) return;
    final maxRain = rainfall.reduce((a, b) => a > b ? a : b);
    final minRain = rainfall.reduce((a, b) => a < b ? a : b);
    final range = (maxRain - minRain).abs() < 1e-3 ? 1.0 : (maxRain - minRain);
    final topPadding = size.height * 0.35;
    final bottomPadding = size.height * 0.32;
    List<Offset> points = [];
    for (int i = 0; i < rainfall.length; i++) {
      final x = i * size.width / (rainfall.length - 1);
      final y = topPadding +
          (size.height - topPadding - bottomPadding) *
              (1 - (rainfall[i] - minRain) / range);
      points.add(Offset(x, y));
    }
    final path = Path();
    if (points.isNotEmpty) {
      path.moveTo(points[0].dx, points[0].dy);
      for (int i = 0; i < points.length - 1; i++) {
        final p0 = i == 0 ? points[0] : points[i - 1];
        final p1 = points[i];
        final p2 = points[i + 1];
        final p3 =
            i + 2 < points.length ? points[i + 2] : points[points.length - 1];
        for (double t = 0; t < 1; t += 0.2) {
          final tt = t * t;
          final ttt = tt * t;
          final x = 0.5 *
              ((2 * p1.dx) +
                  (-p0.dx + p2.dx) * t +
                  (2 * p0.dx - 5 * p1.dx + 4 * p2.dx - p3.dx) * tt +
                  (-p0.dx + 3 * p1.dx - 3 * p2.dx + p3.dx) * ttt);
          final y = 0.5 *
              ((2 * p1.dy) +
                  (-p0.dy + p2.dy) * t +
                  (2 * p0.dy - 5 * p1.dy + 4 * p2.dy - p3.dy) * tt +
                  (-p0.dy + 3 * p1.dy - 3 * p2.dy + p3.dy) * ttt);
          path.lineTo(x, y);
        }
        path.lineTo(p2.dx, p2.dy);
      }
      // 阴影填充
      final shadowPath = Path.from(path)
        ..lineTo(points.last.dx, size.height - bottomPadding)
        ..lineTo(points.first.dx, size.height - bottomPadding)
        ..close();
      final shadowPaint = Paint()
        ..shader = LinearGradient(
          colors: [
            color.withValues(alpha: 0.18),
            color.withValues(alpha: 0.02)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
        ..style = PaintingStyle.fill;
      canvas.drawPath(shadowPath, shadowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RainfallCurveShadowPainter oldDelegate) {
    return oldDelegate.rainfall != rainfall || oldDelegate.color != color;
  }
}
