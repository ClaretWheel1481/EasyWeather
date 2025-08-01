import 'dart:io';
import 'package:battery_optimization_helper/battery_optimization_helper.dart';
import 'package:flutter/material.dart';
import 'package:zephyr/core/utils/notification_utils.dart';
import 'package:zephyr/l10n/generated/app_localizations.dart';

class IgnoreBatteryOptimizationWidget extends StatelessWidget {
  final BuildContext? context;

  const IgnoreBatteryOptimizationWidget({
    super.key,
    this.context,
  });

  Future<void> _requestIgnoreBatteryOptimization(BuildContext context) async {
    if (Platform.isAndroid) {
      try {
        bool isEnabled =
            await BatteryOptimizationHelper.isBatteryOptimizationEnabled();
        if (isEnabled) {
          await BatteryOptimizationHelper.openBatteryOptimizationSettings();
        } else {
          if (context.mounted) {
            NotificationUtils.showSnackBar(
              context,
              AppLocalizations.of(context).iBODisabled,
            );
          }
        }
      } catch (e) {
        debugPrint('Error requesting battery optimization: $e');
      }
    }
  }

  @override
  Widget build(BuildContext buildContext) {
    final context = this.context ?? buildContext;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: Platform.isIOS
              ? null
              : () => _requestIgnoreBatteryOptimization(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.battery_saver,
                    color: Platform.isIOS
                        ? Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.38)
                        : Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          AppLocalizations.of(context)
                              .ignoreBatteryOptimization,
                          style: textTheme.titleMedium?.copyWith(
                              color: Platform.isIOS
                                  ? Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withValues(alpha: 0.38)
                                  : null)),
                      const SizedBox(height: 4),
                      Text(AppLocalizations.of(context).iBODesc,
                          style: textTheme.bodySmall?.copyWith(
                              color: Platform.isIOS
                                  ? Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withValues(alpha: 0.6)
                                  : Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withValues(alpha: 0.6)),
                          maxLines: null,
                          softWrap: true),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
