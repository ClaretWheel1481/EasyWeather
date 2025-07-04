import 'package:zephyr/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../../core/models/city.dart';
import '../../core/api/city_search_api.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/search_error_widget.dart';
import 'widgets/search_results_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  List<City> _results = [];
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
    _debounce = Timer(const Duration(milliseconds: 200), () {
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
    if (!mounted) return;
    setState(() {
      _loading = true;
      _error = '';
    });
    try {
      final results = await CitySearchApi.searchCity(query);
      if (!mounted) return;
      setState(() {
        _results = results;
        _loading = false;
        if (results.isEmpty) {
          _error = AppLocalizations.of(context).noResults;
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = AppLocalizations.of(context).searchError;
      });
    }
  }

  void _onCityTap(City city) async {
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: SearchBarWidget(
        controller: _controller,
        onBack: () => Navigator.of(context).pop(),
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
          if (_error.isNotEmpty)
            SearchErrorWidget(
              error: _error,
              onRetry: () => _onSearch(_controller.text.trim()),
            ),
          Expanded(
            child: SearchResultsWidget(
              results: _results,
              loading: _loading,
              isEmpty: _results.isEmpty && !_loading && _error.isEmpty,
              onCityTap: _onCityTap,
            ),
          ),
        ],
      ),
    );
  }
}
