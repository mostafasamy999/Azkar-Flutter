import '../../domain/entities/DailyPrayerTimes.dart';

/// Parses the Aladhan `/v1/timings/{date}` response.
class DailyPrayerTimesModel {
  static const _order = <String, String>{
    'Fajr': 'الفجر',
    'Sunrise': 'الشروق',
    'Dhuhr': 'الظهر',
    'Asr': 'العصر',
    'Maghrib': 'المغرب',
    'Isha': 'العشاء',
  };

  static DailyPrayerTimes fromJson(Map<String, dynamic> json, DateTime day) {
    final data = json['data'] as Map<String, dynamic>;
    final timings = data['timings'] as Map<String, dynamic>;

    final slots = _order.entries.map((e) {
      return PrayerSlot(
        key: e.key,
        nameAr: e.value,
        time: _parseTime(timings[e.key] as String, day),
        isPrayer: e.key != 'Sunrise',
      );
    }).toList();

    final date = data['date'] as Map<String, dynamic>? ?? {};
    final hijri = date['hijri'] as Map<String, dynamic>? ?? {};
    final hijriMonth = (hijri['month'] as Map<String, dynamic>?)?['ar'] ?? '';
    final hijriDate = '${hijri['day'] ?? ''} $hijriMonth ${hijri['year'] ?? ''} هـ'.trim();

    final method =
        ((data['meta'] as Map<String, dynamic>?)?['method'] as Map<String, dynamic>?)?['name'] ?? '';

    return DailyPrayerTimes(
      slots: slots,
      hijriDate: hijriDate,
      gregorianDate: date['readable']?.toString() ?? '',
      methodName: method.toString(),
    );
  }

  /// Aladhan returns "HH:mm" and sometimes "HH:mm (EET)".
  static DateTime _parseTime(String raw, DateTime day) {
    final hm = raw.trim().split(' ').first.split(':');
    return DateTime(day.year, day.month, day.day, int.parse(hm[0]), int.parse(hm[1]));
  }
}
