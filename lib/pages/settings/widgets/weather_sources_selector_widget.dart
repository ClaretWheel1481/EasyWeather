import 'package:flutter/material.dart';
import 'package:zephyr/app_constants.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../core/notifiers.dart';

class WeatherSourceSelectorWidget extends StatefulWidget {
  final String? weatherSource;
  final Function(String) onWeatherSourceChanged;
  const WeatherSourceSelectorWidget({
    super.key,
    this.weatherSource,
    required this.onWeatherSourceChanged,
  });

  @override
  State<WeatherSourceSelectorWidget> createState() =>
      _WeatherSourceSelectorWidgetState();
}

class _WeatherSourceSelectorWidgetState
    extends State<WeatherSourceSelectorWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);

    return ValueListenableBuilder<String>(
      valueListenable: weatherSourceNotifier,
      builder: (context, weatherSource, _) {
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () => setState(() => _expanded = !_expanded),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    child: Row(
                      children: [
                        Icon(Icons.downloading, color: colorScheme.primary),
                        const SizedBox(width: 8),
                        Text("${l10n.weatherSource} Unavailable now",
                            style: textTheme.titleMedium),
                        const Spacer(),
                        Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                      ],
                    ),
                  ),
                ),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.linearToEaseOut,
                child: _expanded
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        child: Column(
                          children: List.generate(
                              AppConstants.weatherSources.length, (index) {
                            final source = AppConstants.weatherSources[index];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Row(
                                children: [
                                  Radio<String>(
                                    value: source,
                                    groupValue: weatherSource,
                                    onChanged: (String? value) {
                                      if (value != null) {
                                        widget.onWeatherSourceChanged(value);
                                      }
                                    },
                                    activeColor: colorScheme.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        widget.onWeatherSourceChanged(source);
                                      },
                                      child: Text(
                                        source,
                                        style: source == weatherSource
                                            ? textTheme.bodyLarge?.copyWith(
                                                color: colorScheme.primary,
                                                fontWeight: FontWeight.bold,
                                              )
                                            : textTheme.bodyLarge,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        );
      },
    );
  }
}
