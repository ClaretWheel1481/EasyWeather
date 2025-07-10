import 'package:zephyr/app.dart';
import 'package:flutter/material.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../core/notifiers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageSelectorWidget extends StatefulWidget {
  const LanguageSelectorWidget({super.key});

  @override
  State<LanguageSelectorWidget> createState() => _LanguageSelectorWidgetState();
}

class _LanguageSelectorWidgetState extends State<LanguageSelectorWidget> {
  bool _expanded = false;

  final List<String> supportedLanguageNames = [
    'English',
    'Italiano',
    '简体中文',
    '繁體中文',
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);

    return ValueListenableBuilder<int>(
      valueListenable: localeIndexNotifier,
      builder: (context, currentIndex, _) {
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
                        vertical: 20, horizontal: 16),
                    child: Row(
                      children: [
                        Icon(Icons.language, color: colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(l10n.language, style: textTheme.titleMedium),
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
                          children:
                              List.generate(supportedLocales.length, (index) {
                            final isSelected = index == currentIndex;
                            return Material(
                                color: Colors.transparent,
                                child: ListTile(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  title: Text(
                                    supportedLanguageNames[index],
                                    style: isSelected
                                        ? textTheme.bodyLarge?.copyWith(
                                            color: colorScheme.primary,
                                            fontWeight: FontWeight.bold,
                                          )
                                        : textTheme.bodyLarge,
                                  ),
                                  trailing: isSelected
                                      ? Icon(Icons.check,
                                          color: colorScheme.primary)
                                      : null,
                                  onTap: () async {
                                    if (!isSelected) {
                                      localeIndexNotifier.value = index;
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      await prefs.setInt('locale_index', index);
                                    }
                                  },
                                ));
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
