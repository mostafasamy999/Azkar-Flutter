import '../../../../core/utils/Status.dart';
import '../entities/DailyPrayerTimes.dart';

abstract class LocationPrayerTimesRepository {
  /// Today's prayer times computed from the device's exact GPS coordinates.
  Future<NetworkState<DailyPrayerTimes>> getTodayForCurrentLocation();
}
