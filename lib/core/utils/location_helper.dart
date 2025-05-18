import 'package:geocoding/geocoding.dart' as geo;
import 'package:location/location.dart' as loc;

import 'InternetConnection.dart';

class LocationUtils {
  static Future<Map<String, String>> getCurrentCityAndCountry() async {
    if(!await checkInternetConnection()){
      throw Exception('تاكد من اتصال الانترنت');
    }
    final location = loc.Location(); // Use loc.Location to avoid conflict
    Map<String, String> locationData = {
      'city': 'Unknown',
      'country': 'Unknown',
    };

    bool _serviceEnabled;
    loc.PermissionStatus _permissionGranted;

    // Check if location services are enabled
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return locationData;
      }
    }

    // Check if location permissions are granted
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == loc.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != loc.PermissionStatus.granted) {
        return locationData;
      }
    }

    // Get the current location
    final locationDataResult = await location.getLocation();

    // Reverse geocode the coordinates to get the city and country
    final placemarks = await geo.placemarkFromCoordinates(
      locationDataResult.latitude!,
      locationDataResult.longitude!,
    );
    final placemark = placemarks[0];
    locationData = {
      'city': placemark.locality ?? 'Unknown',
      'country': placemark.country ?? 'Unknown',
    };

    return locationData;
  }
}
