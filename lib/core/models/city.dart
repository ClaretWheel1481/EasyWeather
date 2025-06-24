import 'dart:convert';

class City {
  final String name; // 市/县/区名
  final String? admin; // 省/州/行政区
  final String country; // 国家
  final double lat;
  final double lon;

  City({
    required this.name,
    this.admin,
    required this.country,
    required this.lat,
    required this.lon,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['name'],
      admin: json['admin'],
      country: json['country'],
      lat: json['lat'],
      lon: json['lon'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'admin': admin,
        'country': country,
        'lat': lat,
        'lon': lon,
      };

  @override
  String toString() {
    return '$name${admin != null ? '·$admin' : ''}·$country';
  }

  static List<City> listFromJson(String jsonStr) {
    final list = json.decode(jsonStr) as List;
    return list.map((e) => City.fromJson(e)).toList();
  }

  static String listToJson(List<City> cities) {
    return json.encode(cities.map((e) => e.toJson()).toList());
  }

  String get cacheKey => 'weather_${lat}_$lon';
}
