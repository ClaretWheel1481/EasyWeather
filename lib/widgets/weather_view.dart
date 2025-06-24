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
    final now = DateTime.now();

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
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 24,
                itemBuilder: (context, i) {
                  if (i >= weather.hourly.length) return const SizedBox();
                  final h = weather.hourly[i];
                  final t = DateTime.tryParse(h.time);
                  final hourStr = t != null
                      ? '${t.hour.toString().padLeft(2, '0')}:00'
                      : '';
                  final isNow = t != null &&
                      t.year == now.year &&
                      t.month == now.month &&
                      t.day == now.day &&
                      t.hour == now.hour;
                  return Container(
                    width: 80,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: isNow ? colorScheme.primary : colorScheme.surface,
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
            ),
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
