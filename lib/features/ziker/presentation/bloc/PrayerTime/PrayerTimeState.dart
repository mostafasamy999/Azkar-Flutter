// prayer_times_state.dart
import 'package:flutter/foundation.dart';
import '../../../domain/entities/PrayerTime.dart';

@immutable
abstract class PrayerTimesState {
  const PrayerTimesState();
}
// Idle state (default state when nothing is happening)
class PrayerTimesIdle extends PrayerTimesState {
  const PrayerTimesIdle();
}
// State when loading
class PrayerTimesLoading extends PrayerTimesState {
  const PrayerTimesLoading();
}

// State when successful
class PrayerTimesSuccess extends PrayerTimesState {
  final PrayerTime data;

  const PrayerTimesSuccess(this.data);

}

// State when there is an error
class PrayerTimesError extends PrayerTimesState {
  final String message;

  const PrayerTimesError(this.message);
}
