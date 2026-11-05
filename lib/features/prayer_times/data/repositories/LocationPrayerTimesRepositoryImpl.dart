import '../../../../core/utils/InternetConnection.dart';
import '../../../../core/utils/Status.dart';
import '../../../../core/utils/location_helper.dart';
import '../../domain/entities/DailyPrayerTimes.dart';
import '../../domain/repositories/LocationPrayerTimesRepository.dart';
import '../datasources/PrayerTimesByLocationDataSource.dart';
import '../models/DailyPrayerTimesModel.dart';

class LocationPrayerTimesRepositoryImpl implements LocationPrayerTimesRepository {
  final PrayerTimesByLocationDataSource dataSource;

  LocationPrayerTimesRepositoryImpl({required this.dataSource});

  @override
  Future<NetworkState<DailyPrayerTimes>> getTodayForCurrentLocation() async {
    final today = DateTime.now();

    // Fall back to today's cached times (same place) when offline or the
    // location can't be read, so the screen still works without network.
    NetworkState<DailyPrayerTimes> fallback(String message) {
      final cached = dataSource.readCache(today);
      if (cached == null) return NetworkState.error(message);
      final times = DailyPrayerTimesModel.fromJson(cached.json, today)
          .copyWith(placeName: cached.place, fromCache: true);
      return NetworkState.success(times);
    }

    if (!await checkInternetConnection()) {
      return fallback('تاكد من اتصال الانترنت');
    }

    try {
      final position = await LocationUtils.getCurrentPosition();
      final lat = position.latitude;
      final lng = position.longitude;

      final results = await Future.wait([
        dataSource.fetch(lat, lng, today),
        LocationUtils.getPlaceName(lat, lng),
      ]);
      final json = results[0] as Map<String, dynamic>;
      final place = results[1] as String?;

      await dataSource.cache(json, today, place);
      return NetworkState.success(
        DailyPrayerTimesModel.fromJson(json, today).copyWith(placeName: place),
      );
    } on Exception catch (e) {
      final msg = e.toString().replaceFirst('Exception: ', '');
      print('LocationPrayerTimesRepositoryImpl error: $msg');
      // Location messages are already user-facing Arabic; anything else is a server error.
      final isLocationMsg = RegExp(r'[؀-ۿ]').hasMatch(msg);
      return fallback(isLocationMsg ? msg : 'مشكلة في السيرفر, اعد المحاولة لاحقا');
    }
  }
}
