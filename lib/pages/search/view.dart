import 'package:easyweather/core/api/city_search_api.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../../core/models/city.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  List<CitySearchResult> _results = [];
  bool _loading = false;
  String _error = '';
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onTextChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final query = _controller.text.trim();
      if (query.isEmpty) {
        setState(() {
          _results = [];
          _error = '';
        });
        return;
      }
      _onSearch(query);
    });
  }

  void _onSearch(String query) async {
    setState(() {
      _loading = true;
      _error = '';
    });
    try {
      final results = await CitySearchApi.searchCity(query);
      setState(() {
        _results = results;
        _loading = false;
        if (results.isEmpty) {
          _error = '未找到相关城市';
        }
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = '搜索失败，请检查网络';
      });
    }
  }

  void _onCityTap(CitySearchResult city, BuildContext context) async {
    // 解析 admin 和 country
    final parts = city.name.split(',').map((e) => e.trim()).toList();
    String cityName = _extractCityName(city.name);
    String? admin;
    String country = '';
    if (parts.length >= 3) {
      admin = parts[parts.length - 2];
      country = parts.last;
    } else if (parts.length == 2) {
      admin = null;
      country = parts.last;
    } else {
      admin = null;
      country = '';
    }
    final cityObj = City(
      name: cityName,
      admin: admin,
      country: country,
      lat: city.lat,
      lon: city.lon,
    );
    Navigator.pop(context, cityObj);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: '返回',
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
            controller: _controller,
            autofocus: true,
            style: textTheme.titleMedium,
            decoration: InputDecoration(
              hintText: '输入城市名，如"北京"',
              hintStyle: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7)),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              isDense: true,
            ),
            textInputAction: TextInputAction.search,
          ),
        ),
      ),
      backgroundColor: colorScheme.onInverseSurface,
      body: Column(
        children: [
          if (_loading)
            LinearProgressIndicator(
              color: colorScheme.primary,
              backgroundColor: colorScheme.onInverseSurface,
              minHeight: 3,
            ),
          if (_error.isNotEmpty) ...[
            const SizedBox(height: 24),
            FilledButton.tonalIcon(
              onPressed: () => _onSearch(_controller.text.trim()),
              icon: const Icon(Icons.refresh),
              label: Text(_error, style: textTheme.bodyMedium),
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.errorContainer,
                foregroundColor: colorScheme.onErrorContainer,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ],
          Expanded(
              child: _results.isEmpty && !_loading && _error.isEmpty
                  ? Center(
                      child: Text('请输入城市名进行搜索',
                          style: textTheme.bodyMedium
                              ?.copyWith(color: colorScheme.onSurfaceVariant)),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView.separated(
                        itemCount: _results.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final city = _results[index];
                          return Material(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                            elevation: 1,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () => _onCityTap(city, context),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: colorScheme.primary
                                            .withValues(alpha: 0.08),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      child: Icon(Icons.location_city,
                                          color: colorScheme.primary, size: 28),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(_extractCityName(city.name),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: textTheme.titleMedium
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                          const SizedBox(height: 2),
                                          Text(_extractRegionName(city.name),
                                              style: textTheme.bodySmall
                                                  ?.copyWith(
                                                      color: colorScheme
                                                          .onSurfaceVariant)),
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
                    )),
        ],
      ),
    );
  }

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
