import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../../l10n/generated/app_localizations.dart';

class ThemeModeSelectorWidget extends StatelessWidget {
  final ThemeMode? themeMode;
  final bool dynamicColorEnabled;
  final Color customColor;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final ValueChanged<bool> onDynamicColorChanged;
  final ValueChanged<Color> onCustomColorChanged;

  const ThemeModeSelectorWidget({
    super.key,
    required this.themeMode,
    required this.dynamicColorEnabled,
    required this.customColor,
    required this.onThemeModeChanged,
    required this.onDynamicColorChanged,
    required this.onCustomColorChanged,
  });

  void _showColorPicker(BuildContext context) {
    Color pickerColor = customColor;
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.customColor),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: (Color color) {
                pickerColor = color;
              },
              pickerAreaHeightPercent: 0.8,
              enableAlpha: false,
              displayThumbColor: true,
              paletteType: PaletteType.hueWheel,
              labelTypes: const [],
              portraitOnly: true,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FilledButton(
              child: Text(MaterialLocalizations.of(context).okButtonLabel),
              onPressed: () {
                onCustomColorChanged(pickerColor);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 主题模式选择
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.brightness_6, color: colorScheme.primary),
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
          const Divider(),
          // Monet取色开关
          Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: Platform.isIOS
                  ? null
                  : () => onDynamicColorChanged(!dynamicColorEnabled),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Row(
                  children: [
                    Icon(Icons.palette_outlined,
                        color: Platform.isIOS
                            ? colorScheme.onSurface.withValues(alpha: 0.38)
                            : colorScheme.primary),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Text(l10n.monetColor,
                            style: textTheme.titleMedium?.copyWith(
                              color: Platform.isIOS
                                  ? colorScheme.onSurface
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
          const Divider(),
          const SizedBox(height: 12),
          // 自定义颜色选择
          Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: (!dynamicColorEnabled)
                  ? () => _showColorPicker(context)
                  : null,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Row(
                  children: [
                    Icon(
                      Icons.color_lens_outlined,
                      color: (!dynamicColorEnabled)
                          ? colorScheme.primary
                          : colorScheme.onSurface.withValues(alpha: 0.38),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.customColor,
                        style: textTheme.titleMedium?.copyWith(
                          color: (!dynamicColorEnabled)
                              ? null
                              : colorScheme.onSurface.withValues(alpha: 0.38),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
