import 'package:flutter/material.dart';
import 'city_search_service.dart';
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
      final results = await CitySearchService.searchCity(query);
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
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: '输入城市名，如"北京"',
            border: InputBorder.none,
          ),
          textInputAction: TextInputAction.search,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_loading) const LinearProgressIndicator(),
            if (_error.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(_error, style: const TextStyle(color: Colors.red)),
            ],
            Expanded(
              child: ListView.builder(
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  final city = _results[index];
                  return ListTile(
                    leading: const Icon(Icons.location_city),
                    title: Text(_extractCityName(city.name),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: Text(_extractRegionName(city.name)),
                    onTap: () => _onCityTap(city, context),
                  );
                },
              ),
            ),
          ],
        ),
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
