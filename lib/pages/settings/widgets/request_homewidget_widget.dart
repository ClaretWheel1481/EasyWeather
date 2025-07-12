import 'dart:io';

import 'package:home_widget/home_widget.dart';
import 'package:zephyr/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class RequestHomewidgetWidget extends StatelessWidget {
  const RequestHomewidgetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return FutureBuilder<bool?>(
      future: HomeWidget.isRequestPinWidgetSupported(),
      builder: (context, snapshot) {
        final supported = snapshot.data ?? false;
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: supported
                  ? () {
                      HomeWidget.requestPinWidget(
                        name: 'WeatherWidgetProvider',
                        androidName: 'WeatherWidgetProvider',
                        qualifiedAndroidName:
                            'org.claret.zephyr.WeatherWidgetProvider',
                      );
                    }
                  : null,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Row(
                  children: [
                    Icon(Icons.widgets,
                        color: Platform.isIOS
                            ? Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.38)
                            : Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(AppLocalizations.of(context).addHomeWidget,
                        style: textTheme.titleMedium?.copyWith(
                            color: Platform.isIOS
                                ? Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withValues(alpha: 0.38)
                                : null)),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
