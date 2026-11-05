import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'InternetConnection.dart';

class LocationUtils {
  /// Asks for permission if needed and returns the device's current GPS
  /// position. Throws an [Exception] with an Arabic, user-facing message.
  static Future<Position> getCurrentPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('خدمات الموقع غير مفعلة');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('تم رفض إذن الموقع');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('تم رفض إذن الموقع نهائياً - يرجى تفعيله من الإعدادات');
    }

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );
    } catch (e) {
      print('High accuracy failed, trying medium accuracy: $e');
      try {
        return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium,
          timeLimit: const Duration(seconds: 10),
        );
      } catch (e) {
        final last = await Geolocator.getLastKnownPosition();
        if (last != null) return last;
        throw Exception('تعذر تحديد موقعك، حاول مرة اخرى');
      }
    }
  }

  /// Best-effort human-readable place name ("City, Country"); null on failure.
  static Future<String?> getPlaceName(double lat, double lng) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isEmpty) return null;
      final p = placemarks.first;
      final city = _getBestCityName(p);
      final parts = [if (city != 'Unknown') city, if (p.country != null) p.country!];
      return parts.isEmpty ? null : parts.join('، ');
    } catch (_) {
      return null;
    }
  }

  static Future<Map<String, String>> getCurrentCityAndCountry() async {
    Map<String, String> locationData = {
      'city': 'Unknown',
      'country': 'Unknown',
    };

    try {
      // Check internet connection
      if (!await checkInternetConnection()) {
        throw Exception('تاكد من اتصال الانترنت');
      }

      final position = await getCurrentPosition();

      print('Position obtained: ${position.latitude}, ${position.longitude}');

      // Reverse geocode with retry logic
      List<Placemark> placemarks = [];
      int retryCount = 0;
      const maxRetries = 3;

      while (placemarks.isEmpty && retryCount < maxRetries) {
        try {
          placemarks = await placemarkFromCoordinates(
            position.latitude,
            position.longitude,
          );
          break;
        } catch (e) {
          retryCount++;
          print('Geocoding attempt $retryCount failed: $e');
          if (retryCount < maxRetries) {
            await Future.delayed(Duration(seconds: 2));
          }
        }
      }

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        print('Placemark found: ${placemark.toString()}');

        locationData = {
          'city': _getBestCityName(placemark),
          'country': placemark.country ?? 'Unknown',
        };
      } else {
        throw Exception('لم يتم العثور على معلومات الموقع');
      }

    } catch (e) {
      print('Location error: $e');
      rethrow;
    }

    return locationData;
  }

  // Helper method to get the best available city name
  static String _getBestCityName(Placemark placemark) {
    return placemark.locality ??
        placemark.subAdministrativeArea ??
        placemark.administrativeArea ??
        'Unknown';
  }

  // Alternative method for testing - gets last known position
  static Future<Map<String, String>> getLastKnownLocation() async {
    try {
      Position? position = await Geolocator.getLastKnownPosition();
      if (position != null) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          Placemark placemark = placemarks[0];
          return {
            'city': _getBestCityName(placemark),
            'country': placemark.country ?? 'Unknown',
          };
        }
      }
    } catch (e) {
      print('Last known location error: $e');
    }

    return {
      'city': 'Unknown',
      'country': 'Unknown',
    };
  }
}