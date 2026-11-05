import 'package:equatable/equatable.dart';

/// One prayer (or sunrise) with its time for a specific day.
class PrayerSlot extends Equatable {
  final String key; // Fajr, Sunrise, Dhuhr, Asr, Maghrib, Isha
  final String nameAr;
  final DateTime time;
  final bool isPrayer; // false for Sunrise

  const PrayerSlot({
    required this.key,
    required this.nameAr,
    required this.time,
    this.isPrayer = true,
  });

  @override
  List<Object?> get props => [key, time];
}

/// Prayer times for one day at the user's exact coordinates.
class DailyPrayerTimes extends Equatable {
  final List<PrayerSlot> slots;
  final String hijriDate;
  final String gregorianDate;
  final String methodName;
  final String? placeName;
  final bool fromCache;

  const DailyPrayerTimes({
    required this.slots,
    required this.hijriDate,
    required this.gregorianDate,
    required this.methodName,
    this.placeName,
    this.fromCache = false,
  });

  /// Next actual prayer (Sunrise is skipped). After Isha it returns
  /// tomorrow's Fajr, approximated from today's Fajr time.
  PrayerSlot nextPrayer(DateTime now) {
    final prayers = slots.where((s) => s.isPrayer).toList();
    for (final p in prayers) {
      if (p.time.isAfter(now)) return p;
    }
    final fajr = prayers.first;
    return PrayerSlot(
      key: fajr.key,
      nameAr: fajr.nameAr,
      time: fajr.time.add(const Duration(days: 1)),
    );
  }

  DailyPrayerTimes copyWith({String? placeName, bool? fromCache}) {
    return DailyPrayerTimes(
      slots: slots,
      hijriDate: hijriDate,
      gregorianDate: gregorianDate,
      methodName: methodName,
      placeName: placeName ?? this.placeName,
      fromCache: fromCache ?? this.fromCache,
    );
  }

  @override
  List<Object?> get props =>
      [slots, hijriDate, gregorianDate, methodName, placeName, fromCache];
}
