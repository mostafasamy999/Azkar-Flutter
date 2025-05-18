import '../../../../core/utils/Status.dart';
import '../entities/PrayerTime.dart';
import '../repositories/PrayerTimeRepository.dart';

class GetPrayerTimesUsecase {
  final PrayerTimeRepository repository;

  GetPrayerTimesUsecase(this.repository);

  Future<NetworkState<PrayerTime>> call(String city, String country) async {
    return await repository.getPrayerTimes(city, country);
  }
}
