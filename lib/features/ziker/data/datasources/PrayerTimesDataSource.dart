import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/PrayerTimeResponse.dart';

abstract class PrayerTimesRemoteDataSource {
  Future<PrayerTimeResponse> getPrayerTimes(String city, String country);
}

class PrayerTimesRemoteDataSourceImpl implements PrayerTimesRemoteDataSource {
  final http.Client client;

  PrayerTimesRemoteDataSourceImpl({required this.client});

  @override
  Future<PrayerTimeResponse> getPrayerTimes(String city, String country) async {
    final url = 'http://api.aladhan.com/v1/timingsByCity?city=$city&country=$country';

    final response = await client.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return PrayerTimeResponse.fromJson(data);
    } else {
      throw Exception('Failed to load prayer times');
    }
  }
}
