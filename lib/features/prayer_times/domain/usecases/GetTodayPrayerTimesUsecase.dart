import '../../../../core/utils/Status.dart';
import '../entities/DailyPrayerTimes.dart';
import '../repositories/LocationPrayerTimesRepository.dart';

class GetTodayPrayerTimesUsecase {
  final LocationPrayerTimesRepository repository;

  GetTodayPrayerTimesUsecase(this.repository);

  Future<NetworkState<DailyPrayerTimes>> call() => repository.getTodayForCurrentLocation();
}
