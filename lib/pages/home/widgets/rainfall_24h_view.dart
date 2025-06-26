import 'package:easyweather/l10n/generated/app_localizations.dart';
import 'package:easyweather/pages/home/widgets/section_title.dart';
import 'package:flutter/material.dart';
import '../../../core/models/weather.dart';

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
        Container(
          height: 200,
          padding: const EdgeInsets.symmetric(vertical: 15),
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
    final extendedRainfall = [0.0, ...rainfall, 0.0];
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final maxRain = extendedRainfall.reduce((a, b) => a > b ? a : b);
    final minRain = extendedRainfall.reduce((a, b) => a < b ? a : b);
    final range = (maxRain - minRain).abs() < 1e-3 ? 1.0 : (maxRain - minRain);
    final topPadding = size.height * 0.22;
    final bottomPadding = size.height * 0.18;
    List<Offset> points = [];
    for (int i = 0; i < extendedRainfall.length; i++) {
      final x = (i - 0.5) * size.width / rainfall.length;
      final y = topPadding +
          (size.height - topPadding - bottomPadding) *
              (1 - (extendedRainfall[i] - minRain) / range);
      points.add(Offset(x, y));
    }
    final path = Path();
    if (points.isNotEmpty) {
      path.moveTo(points[0].dx, points[0].dy);
      for (int i = 1; i < points.length - 1; i++) {
        final curr = points[i];
        final next = points[i + 1];
        // 控制点为当前点，终点为当前点和下一个点的中点
        final controlPoint = curr;
        final endPoint = Offset(
          (curr.dx + next.dx) / 2,
          (curr.dy + next.dy) / 2,
        );
        path.quadraticBezierTo(
          controlPoint.dx,
          controlPoint.dy,
          endPoint.dx,
          endPoint.dy,
        );
      }
      // 最后一段直接连到最后一个点
      path.lineTo(points.last.dx, points.last.dy);
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
    final extendedRainfall = [0.0, ...rainfall, 0.0];
    final maxRain = extendedRainfall.reduce((a, b) => a > b ? a : b);
    final minRain = extendedRainfall.reduce((a, b) => a < b ? a : b);
    final range = (maxRain - minRain).abs() < 1e-3 ? 1.0 : (maxRain - minRain);
    final topPadding = size.height * 0.22;
    final bottomPadding = size.height * 0.18;
    List<Offset> points = [];
    for (int i = 0; i < extendedRainfall.length; i++) {
      final x = (i - 0.5) * size.width / rainfall.length;
      final y = topPadding +
          (size.height - topPadding - bottomPadding) *
              (1 - (extendedRainfall[i] - minRain) / range);
      points.add(Offset(x, y));
    }
    final path = Path();
    if (points.isNotEmpty) {
      path.moveTo(points[0].dx, points[0].dy);
      for (int i = 1; i < points.length - 1; i++) {
        final curr = points[i];
        final next = points[i + 1];
        // 控制点为当前点，终点为当前点和下一个点的中点
        final controlPoint = curr;
        final endPoint = Offset(
          (curr.dx + next.dx) / 2,
          (curr.dy + next.dy) / 2,
        );
        path.quadraticBezierTo(
          controlPoint.dx,
          controlPoint.dy,
          endPoint.dx,
          endPoint.dy,
        );
      }
      // 最后一段直接连到最后一个点
      path.lineTo(points.last.dx, points.last.dy);
    }
    // 阴影填充
    final shadowPath = Path.from(path)
      ..lineTo(points.last.dx, size.height - bottomPadding)
      ..lineTo(points.first.dx, size.height - bottomPadding)
      ..close();
    final shadowPaint = Paint()
      ..shader = LinearGradient(
        colors: [color.withValues(alpha: 0.18), color.withValues(alpha: 0.02)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;
    canvas.drawPath(shadowPath, shadowPaint);
  }

  @override
  bool shouldRepaint(covariant _RainfallCurveShadowPainter oldDelegate) {
    return oldDelegate.rainfall != rainfall || oldDelegate.color != color;
  }
}
