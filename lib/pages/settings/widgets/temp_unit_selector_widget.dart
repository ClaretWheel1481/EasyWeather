import 'package:flutter/material.dart';
import '../../../l10n/generated/app_localizations.dart';

class TempUnitSelectorWidget extends StatelessWidget {
  final String? tempUnit;
  final Function(String) onTempUnitChanged;

  const TempUnitSelectorWidget({
    super.key,
    this.tempUnit,
    required this.onTempUnitChanged,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.thermostat,
                      color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.temperatureUnit,
                            style: textTheme.titleMedium),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: SegmentedButton<String>(
                            segments: [
                              ButtonSegment(
                                value: 'C',
                                icon: const Icon(Icons.thermostat_outlined),
                                label: Text(l10n.celsius),
                              ),
                              ButtonSegment(
                                value: 'F',
                                icon: const Icon(Icons.thermostat_outlined),
                                label: Text(l10n.fahrenheit),
                              ),
                            ],
                            selected: {tempUnit ?? 'C'},
                            onSelectionChanged: (units) {
                              if (units.isNotEmpty) {
                                onTempUnitChanged(units.first);
                              }
                            },
                            showSelectedIcon: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
