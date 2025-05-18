// lib/data/models/prayer_time_response.dart

import 'package:flutter/material.dart';

import '../../domain/entities/PrayerTime.dart';

class PrayerTimeResponse {
  final String fajr;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;

  PrayerTimeResponse({
    required this.fajr,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  // Factory method to parse the JSON response
  factory PrayerTimeResponse.fromJson(Map<String, dynamic> json) {

    // Navigate through the nested structure of the JSON
    final timings = json['data']['timings'];

    return PrayerTimeResponse(
      fajr: timings['Fajr'] ?? 'N/A',
      dhuhr: timings['Dhuhr'] ?? 'N/A',
      asr: timings['Asr'] ?? 'N/A',
      maghrib: timings['Maghrib'] ?? 'N/A',
      isha: timings['Isha'] ?? 'N/A',
    );
  }

  // Convert the response to domain entity
  PrayerTime toDomain() {
    return PrayerTime(
      fajr: stringToTimeOfDay(fajr),
      dhuhr: stringToTimeOfDay(dhuhr),
      asr: stringToTimeOfDay(asr),
      maghrib: stringToTimeOfDay(maghrib),
      isha: stringToTimeOfDay(isha),
    );
  }

  TimeOfDay stringToTimeOfDay(String timeString) {
    final format = timeString.split(':');
    final hour = int.parse(format[0]);
    final minute = int.parse(format[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }
}
