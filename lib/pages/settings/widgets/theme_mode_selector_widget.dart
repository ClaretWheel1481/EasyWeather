import 'dart:io';
import 'package:flutter/material.dart';
import '../../../l10n/generated/app_localizations.dart';

class ThemeModeSelectorWidget extends StatelessWidget {
  final ThemeMode? themeMode;
  final bool dynamicColorEnabled;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final ValueChanged<bool> onDynamicColorChanged;

  const ThemeModeSelectorWidget({
    super.key,
    required this.themeMode,
    required this.dynamicColorEnabled,
    required this.onThemeModeChanged,
    required this.onDynamicColorChanged,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.brightness_6,
                        color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.themeMode, style: textTheme.titleMedium),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: SegmentedButton<ThemeMode>(
                              segments: [
                                ButtonSegment(
                                  value: ThemeMode.system,
                                  label: Text(l10n.system),
                                  icon: const Icon(Icons.phone_android),
                                ),
                                ButtonSegment(
                                  value: ThemeMode.light,
                                  label: Text(l10n.light),
                                  icon: const Icon(Icons.light_mode),
                                ),
                                ButtonSegment(
                                  value: ThemeMode.dark,
                                  label: Text(l10n.dark),
                                  icon: const Icon(Icons.dark_mode),
                                ),
                              ],
                              selected: {themeMode ?? ThemeMode.system},
                              onSelectionChanged: (modes) {
                                if (modes.isNotEmpty) {
                                  onThemeModeChanged(modes.first);
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
                const SizedBox(height: 12),
              ],
            ),
          ),
          Divider(),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              onTap: Platform.isIOS
                  ? null
                  : () => onDynamicColorChanged(!dynamicColorEnabled),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Row(
                  children: [
                    Icon(Icons.palette_outlined,
                        color: Platform.isIOS
                            ? Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.38)
                            : Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Text(l10n.monetColor,
                            style: textTheme.titleMedium?.copyWith(
                              color: Platform.isIOS
                                  ? Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withValues(alpha: 0.38)
                                  : null,
                            ))),
                    Switch(
                      value: dynamicColorEnabled,
                      onChanged: Platform.isIOS ? null : onDynamicColorChanged,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
