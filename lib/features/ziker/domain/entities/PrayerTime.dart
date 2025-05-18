

import 'package:flutter/material.dart';

class PrayerTime {
   TimeOfDay fajr;
   TimeOfDay dhuhr;
   TimeOfDay asr;
   TimeOfDay maghrib;
   TimeOfDay isha;

  PrayerTime({
    required this.fajr,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });
}
