import 'package:flutter/material.dart';
import '../../../l10n/generated/app_localizations.dart';

class SearchErrorWidget extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const SearchErrorWidget({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        const SizedBox(height: 24),
        FilledButton.tonalIcon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh),
          label: Text("${l10n.searchError}, ${l10n.retry}",
              style: textTheme.bodyMedium),
          style: FilledButton.styleFrom(
            backgroundColor: colorScheme.errorContainer,
            foregroundColor: colorScheme.onErrorContainer,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          ),
        ),
      ],
    );
  }
}
