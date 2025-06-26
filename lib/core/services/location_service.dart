import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../models/city.dart';

class LocationService {
  static Future<Position?> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }
    if (permission == LocationPermission.deniedForever) return null;

    return await Geolocator.getCurrentPosition();
  }

  static Future<City> getCityFromPosition(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        return City(
          name: p.locality ??
              p.name ??
              "${position.latitude.toStringAsFixed(4)},${position.longitude.toStringAsFixed(4)}",
          admin: p.administrativeArea,
          country: p.country ?? '',
          lat: position.latitude,
          lon: position.longitude,
        );
      }
      return City(
        name:
            "${position.latitude.toStringAsFixed(4)},${position.longitude.toStringAsFixed(4)}",
        admin: null,
        country: '',
        lat: position.latitude,
        lon: position.longitude,
      );
    } catch (e) {
      return City(
        name:
            "${position.latitude.toStringAsFixed(4)},${position.longitude.toStringAsFixed(4)}",
        admin: null,
        country: '',
        lat: position.latitude,
        lon: position.longitude,
      );
    }
  }
}
