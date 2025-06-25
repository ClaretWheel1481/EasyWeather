import 'package:flutter/material.dart';
import '../../../core/models/city.dart';
import '../../../l10n/generated/app_localizations.dart';

class CityManagerWidget extends StatelessWidget {
  final List<City> cities;
  final int mainCityIndex;
  final bool cityLoading;
  final bool cityManagerExpanded;
  final ValueChanged<int> onSetMainCity;
  final ValueChanged<int> onRemoveCity;
  final VoidCallback onToggleExpand;

  const CityManagerWidget({
    super.key,
    required this.cities,
    required this.mainCityIndex,
    required this.cityLoading,
    required this.cityManagerExpanded,
    required this.onSetMainCity,
    required this.onRemoveCity,
    required this.onToggleExpand,
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
          InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: onToggleExpand,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Row(
                children: [
                  Icon(Icons.location_city,
                      color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(l10n.cityManager, style: textTheme.titleMedium),
                  const Spacer(),
                  Icon(cityManagerExpanded
                      ? Icons.expand_less
                      : Icons.expand_more),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.linearToEaseOut,
            child: cityManagerExpanded
                ? Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        cityLoading
                            ? const Center(child: CircularProgressIndicator())
                            : cities.isEmpty
                                ? Center(child: Text(l10n.noCitiesAdded))
                                : ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: cities.length,
                                    separatorBuilder: (_, __) =>
                                        const Divider(height: 1),
                                    itemBuilder: (context, index) {
                                      final city = cities[index];
                                      final isMain = index == mainCityIndex;
                                      return ListTile(
                                        leading: Icon(
                                          isMain
                                              ? Icons.star
                                              : Icons.location_city,
                                          color: isMain ? Colors.amber : null,
                                        ),
                                        title: Text(city.name),
                                        subtitle: Text(
                                          city.admin != null &&
                                                  city.admin!.isNotEmpty
                                              ? '${city.admin} · ${city.country}'
                                              : city.country,
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (!isMain)
                                              IconButton(
                                                icon: const Icon(
                                                    Icons.star_border),
                                                tooltip: 'Set as main city',
                                                onPressed: () =>
                                                    onSetMainCity(index),
                                              ),
                                            IconButton(
                                              icon: const Icon(
                                                  Icons.delete_outline),
                                              tooltip: l10n.delete,
                                              onPressed: isMain &&
                                                      cities.length == 1
                                                  ? null
                                                  : () => onRemoveCity(index),
                                            ),
                                          ],
                                        ),
                                        onTap: !isMain
                                            ? () => onSetMainCity(index)
                                            : null,
                                      );
                                    },
                                  ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
