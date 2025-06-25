import 'package:easyweather/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../../core/models/city.dart';

class SearchResultsWidget extends StatelessWidget {
  final List<City> results;
  final bool loading;
  final bool isEmpty;
  final ValueChanged<City> onCityTap;

  const SearchResultsWidget({
    super.key,
    required this.results,
    required this.loading,
    required this.isEmpty,
    required this.onCityTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (isEmpty && !loading) {
      return Center(
        child: Text(
          AppLocalizations.of(context).searchHintOnSurface,
          style: textTheme.bodyLarge
              ?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
      child: ListView.separated(
        itemCount: results.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final city = results[index];
          return Material(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            elevation: 0,
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () => onCityTap(city),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        Icons.location_city,
                        color: colorScheme.primary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _extractCityName(city.name),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _extractRegionName(city.name),
                            style: textTheme.bodySmall
                                ?.copyWith(color: colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Chinese Available
  String _extractCityName(String displayName) {
    // 只取市或县级名称
    final parts = displayName.split(',').map((e) => e.trim()).toList();
    for (final p in parts) {
      if (p.endsWith('市') || p.endsWith('县') || p.endsWith('区')) {
        return p;
      }
    }
    // 若无市县区，取第一个
    return parts.isNotEmpty ? parts[0] : displayName;
  }

  String _extractRegionName(String displayName) {
    // 提取省/国家级信息
    final parts = displayName.split(',').map((e) => e.trim()).toList();
    if (parts.length >= 3) {
      // 取倒数第二和最后一个（如"北京市, 北京市, 中国"）
      return '${parts[parts.length - 2]} · ${parts.last}';
    } else if (parts.length == 2) {
      return parts.last;
    }
    return '';
  }
}
