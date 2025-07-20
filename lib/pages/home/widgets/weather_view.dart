import 'package:zephyr/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../../core/models/city.dart';
import '../../../core/models/weather.dart';
import '../../../core/models/weather_warning.dart';
import '../../../core/utils/weather_utils.dart';
import '../../../core/notifiers.dart';
import 'weather_info_tile.dart';
import 'section_title.dart';
import 'rainfall_24h_view.dart';
import 'future_weather_band.dart';
import 'details_widget.dart';
import 'warning_banner.dart';
import 'package:intl/intl.dart';

class WeatherView extends StatefulWidget {
  final City city;
  final WeatherData weather;
  final List<WeatherWarning> warnings;
  const WeatherView(
      {super.key,
      required this.city,
      required this.weather,
      this.warnings = const []});

  @override
  State<WeatherView> createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView>
    with SingleTickerProviderStateMixin {
  bool _showWarning = false;
  late final AnimationController _bannerController;
  late final Animation<Offset> _bannerOffsetAnimation;
  late final Animation<double> _bannerFadeAnimation;

  String formatPubTime(String pubTime) {
    try {
      final dt = DateTime.parse(pubTime).toLocal();
      return DateFormat('yyyy-MM-dd HH:mm').format(dt);
    } catch (e) {
      return pubTime;
    }
  }

  @override
  void initState() {
    super.initState();
    _bannerController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
    _bannerOffsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _bannerController,
      curve: Curves.easeOutCubic,
    ));
    _bannerFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _bannerController,
      curve: Curves.easeIn,
    ));
  }

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  void _toggleWarning() {
    if (_showWarning) {
      _bannerController.reverse().then((_) {
        if (mounted) setState(() => _showWarning = false);
      });
    } else {
      setState(() {
        _showWarning = true;
      });
      _bannerController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = widget.weather.current;
    final daily = widget.weather.daily;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final hasWarning = widget.warnings.isNotEmpty;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 顶部天气卡片
              if (current != null)
                Stack(
                  children: [
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
                            Text(
                                getLocalizedWeatherDesc(
                                    context, current.weatherCode),
                                style: textTheme.titleMedium?.copyWith(
                                  color: colorScheme.onPrimaryContainer,
                                )),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                WeatherInfoTile(
                                  icon: Icons.thermostat,
                                  label: AppLocalizations.of(context).feelsLike,
                                  value: current.apparentTemperature != null
                                      ? current.apparentTemperature!
                                          .toStringAsFixed(1)
                                      : '-',
                                  unit: '°${tempUnitNotifier.value}',
                                ),
                                WeatherInfoTile(
                                  icon: Icons.water_drop,
                                  label: AppLocalizations.of(context).humidity,
                                  value: current.humidity != null
                                      ? current.humidity!.toStringAsFixed(0)
                                      : '-',
                                  unit: '%',
                                ),
                                WeatherInfoTile(
                                  icon: Icons.navigation,
                                  label: AppLocalizations.of(context)
                                      .windDirection,
                                  value: current.windDirection != null
                                      ? getLocalizedWindDirection(
                                          context, current.windDirection!)
                                      : '-',
                                  unit: '',
                                ),
                                WeatherInfoTile(
                                  icon: current.pm25 != null
                                      ? getAirQualityIcon(getAirQualityLevel(
                                          pm25: current.pm25,
                                          pm10: current.pm10))
                                      : Icons.air,
                                  label:
                                      AppLocalizations.of(context).airQuality,
                                  value: current.pm25 != null
                                      ? getLocalizedAirQualityDesc(
                                          context,
                                          getAirQualityLevel(
                                              pm25: current.pm25,
                                              pm10: current.pm10))
                                      : '-',
                                  unit: '',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (hasWarning)
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Material(
                          color: colorScheme.error,
                          borderRadius: BorderRadius.circular(24),
                          elevation: 3,
                          shadowColor: colorScheme.error.withValues(alpha: 0.2),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(24),
                            onTap: _toggleWarning,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.error_outline,
                                      color: colorScheme.onError),
                                  const SizedBox(width: 4),
                                  Text(
                                    AppLocalizations.of(context).alert,
                                    style: textTheme.titleMedium?.copyWith(
                                      color: colorScheme.onError,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              const SizedBox(height: 20),
              // 24小时天气
              SectionTitle(AppLocalizations.of(context).hourlyForecast),
              const SizedBox(height: 8),
              if (widget.weather.hourly.isNotEmpty)
                Builder(
                  builder: (context) {
                    final now = DateTime.now();
                    int startIdx = 0;
                    for (int i = 0; i < widget.weather.hourly.length; i++) {
                      final t =
                          DateTime.tryParse(widget.weather.hourly[i].time);
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
                        (startIdx + 24) <= widget.weather.hourly.length
                            ? (startIdx + 24)
                            : widget.weather.hourly.length;
                    final hours =
                        widget.weather.hourly.sublist(startIdx, endIdx);
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
                            width: 75,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: isNow
                                  ? colorScheme.primary
                                  : colorScheme.surface,
                              borderRadius: BorderRadius.circular(24),
                              border: isNow
                                  ? Border.all(
                                      color: colorScheme.primary, width: 2)
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
              Rainfall24hView(hourly: widget.weather.hourly),
              const SizedBox(height: 24),
              // 未来天气
              SectionTitle(AppLocalizations.of(context).next7Days),
              const SizedBox(height: 8),
              if (daily.isNotEmpty)
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                  color: colorScheme.surface,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
                    child: SizedBox(
                      height: 230,
                      child: FutureWeatherBand(
                          daily: daily,
                          colorScheme: colorScheme,
                          textTheme: textTheme),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              SectionTitle(AppLocalizations.of(context).detailedData),
              const SizedBox(height: 8),
              // 详细数据
              DetailedDataWidget(
                  current: current,
                  daily: daily.first,
                  hourly: widget.weather.hourly),
              const SizedBox(height: 24),
            ],
          ),
        ),
        // 天气预警Banner
        WarningBanner(
          warnings: widget.warnings,
          show: _showWarning && hasWarning,
          offsetAnimation: _bannerOffsetAnimation,
          fadeAnimation: _bannerFadeAnimation,
          onClose: _toggleWarning,
        ),
      ],
    );
  }
}
