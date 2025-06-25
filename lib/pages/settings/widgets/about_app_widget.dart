import 'package:easyweather/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../../app_constants.dart';

class AboutAppWidget extends StatelessWidget {
  const AboutAppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {
          showAboutDialog(
            context: context,
            applicationName: AppConstants.appName,
            applicationVersion: AppConstants.appVersion,
            applicationLegalese: AppConstants.appDescription,
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Row(
            children: [
              Icon(Icons.info_outline,
                  color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              Text(AppLocalizations.of(context).about,
                  style: textTheme.titleMedium),
            ],
          ),
        ),
      ),
    );
  }
}
