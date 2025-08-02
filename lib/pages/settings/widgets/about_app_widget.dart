import 'package:url_launcher/url_launcher.dart';
import 'package:zephyr/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../../app_constants.dart';

class AboutAppWidget extends StatelessWidget {
  const AboutAppWidget({super.key});

  Future<void> _launchUrl() async {
    await launchUrl(Uri.parse(AppConstants.appUrl));
  }

  @override
  Widget build(BuildContext context) {
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
          onTap: () {
            showAboutDialog(
                context: context,
                applicationIcon: Image.asset(
                  'assets/images/zephyr.png',
                  width: 64,
                  height: 64,
                ),
                applicationName: AppConstants.appName,
                applicationVersion: AppConstants.appVersion,
                applicationLegalese: AppConstants.appDescription,
                children: [
                  const SizedBox(height: 16),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(24),
                            onTap: () async {
                              await _launchUrl();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 16),
                              child: Row(
                                children: [
                                  Icon(Icons.star,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                  const SizedBox(width: 8),
                                  Text(AppLocalizations.of(context).starUs,
                                      style: textTheme.titleMedium),
                                ],
                              ),
                            ),
                          )))
                ]);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
      ),
    );
  }
}
