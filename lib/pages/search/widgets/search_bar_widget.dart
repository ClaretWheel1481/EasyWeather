import 'package:flutter/material.dart';
import '../../../l10n/generated/app_localizations.dart';

class SearchBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController controller;
  final VoidCallback onBack;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);

    return AppBar(
      backgroundColor: colorScheme.surface,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
      ),
      titleSpacing: 0,
      title: Container(
        height: 44,
        decoration: BoxDecoration(
          color: colorScheme.onInverseSurface,
          borderRadius: BorderRadius.circular(24),
        ),
        alignment: Alignment.centerLeft,
        child: TextField(
          controller: controller,
          autofocus: true,
          style: textTheme.titleMedium,
          decoration: InputDecoration(
            hintText: l10n.searchHint,
            hintStyle: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            isDense: true,
          ),
          textInputAction: TextInputAction.search,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
