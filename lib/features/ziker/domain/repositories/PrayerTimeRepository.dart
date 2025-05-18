// lib/domain/repositories/prayer_time_repository.dart

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/Status.dart';
import '../../data/models/PrayerTimeResponse.dart';
import '../entities/PrayerTime.dart';

abstract class PrayerTimeRepository {
  Future<NetworkState<PrayerTime>> getPrayerTimes(String city, String country);
}
