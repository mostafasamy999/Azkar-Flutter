import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

abstract class PrayerTimesByLocationDataSource {
  /// Raw Aladhan JSON for [day] at the exact coordinates.
  Future<Map<String, dynamic>> fetch(double lat, double lng, DateTime day);

  Future<void> cache(Map<String, dynamic> json, DateTime day, String? place);

  /// Cached JSON + place name for [day], or null.
  ({Map<String, dynamic> json, String? place})? readCache(DateTime day);
}

class PrayerTimesByLocationDataSourceImpl implements PrayerTimesByLocationDataSource {
  final http.Client client;
  final SharedPreferences prefs;

  static const _kJson = 'prayer_times_cache_json';
  static const _kDay = 'prayer_times_cache_day';
  static const _kPlace = 'prayer_times_cache_place';

  PrayerTimesByLocationDataSourceImpl({required this.client, required this.prefs});

  static String _dayKey(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}';

  @override
  Future<Map<String, dynamic>> fetch(double lat, double lng, DateTime day) async {
    // No `method` param: Aladhan picks the official calculation authority
    // closest to these coordinates (e.g. Egyptian General Authority in Egypt,
    // Umm Al-Qura in KSA), and computes the timezone from the coordinates.
    final uri = Uri.https('api.aladhan.com', '/v1/timings/${_dayKey(day)}', {
      'latitude': lat.toStringAsFixed(6),
      'longitude': lng.toStringAsFixed(6),
    });
    final response = await client.get(uri).timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) {
      throw Exception('Aladhan ${response.statusCode}');
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  @override
  Future<void> cache(Map<String, dynamic> json, DateTime day, String? place) async {
    await prefs.setString(_kJson, jsonEncode(json));
    await prefs.setString(_kDay, _dayKey(day));
    if (place != null) {
      await prefs.setString(_kPlace, place);
    } else {
      await prefs.remove(_kPlace);
    }
  }

  @override
  ({Map<String, dynamic> json, String? place})? readCache(DateTime day) {
    if (prefs.getString(_kDay) != _dayKey(day)) return null;
    final raw = prefs.getString(_kJson);
    if (raw == null) return null;
    return (json: jsonDecode(raw) as Map<String, dynamic>, place: prefs.getString(_kPlace));
  }
}
