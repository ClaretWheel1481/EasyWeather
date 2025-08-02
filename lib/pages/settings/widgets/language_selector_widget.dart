import 'package:zephyr/app.dart';
import 'package:flutter/material.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../core/notifiers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/languages.dart';

class LanguageSelectorWidget extends StatefulWidget {
  const LanguageSelectorWidget({super.key});

  @override
  State<LanguageSelectorWidget> createState() => _LanguageSelectorWidgetState();
}

class _LanguageSelectorWidgetState extends State<LanguageSelectorWidget> {
  final List<String> supportedLanguageNames =
      appLanguages.map((e) => e.name).toList();

  void _showLanguageDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ValueListenableBuilder<String>(
          valueListenable: localeCodeNotifier,
          builder: (context, localeCode, _) {
            final currentIndex =
                appLanguages.indexWhere((l) => l.code == localeCode);

            return AlertDialog(
              title: Text(l10n.language),
              content: SingleChildScrollView(
                child: Column(
                  children: List.generate(supportedLocales.length, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 1),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: currentIndex == index
                            ? colorScheme.primary.withValues(alpha: 0.1)
                            : Colors.transparent,
                      ),
                      child: RadioListTile<int>(
                        title: Text(
                          supportedLanguageNames[index],
                          style: currentIndex == index
                              ? textTheme.bodyLarge?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                )
                              : textTheme.bodyLarge,
                        ),
                        value: index,
                        groupValue: currentIndex,
                        activeColor: colorScheme.primary,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 8),
                        dense: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        onChanged: (int? value) async {
                          if (value != null && value != currentIndex) {
                            localeCodeNotifier.value = appLanguages[value].code;
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setString(
                                'locale_code', appLanguages[value].code);
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    );
                  }),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    MaterialLocalizations.of(context).closeButtonLabel,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);

    return ValueListenableBuilder<String>(
      valueListenable: localeCodeNotifier,
      builder: (context, localeCode, _) {
        final currentIndex =
            appLanguages.indexWhere((l) => l.code == localeCode);
        final currentLanguageName = currentIndex >= 0
            ? supportedLanguageNames[currentIndex]
            : supportedLanguageNames[0];

        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () => _showLanguageDialog(context),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.language,
                        color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.language, style: textTheme.titleMedium),
                          const SizedBox(height: 4),
                          Text(
                            currentLanguageName,
                            style: textTheme.bodySmall?.copyWith(
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    )
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
