import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/DailyPrayerTimes.dart';
import '../../domain/usecases/GetTodayPrayerTimesUsecase.dart';

sealed class PrayerTimesScreenState extends Equatable {
  const PrayerTimesScreenState();
  @override
  List<Object?> get props => [];
}

class PrayerTimesScreenLoading extends PrayerTimesScreenState {
  const PrayerTimesScreenLoading();
}

class PrayerTimesScreenLoaded extends PrayerTimesScreenState {
  final DailyPrayerTimes times;
  const PrayerTimesScreenLoaded(this.times);
  @override
  List<Object?> get props => [times];
}

class PrayerTimesScreenError extends PrayerTimesScreenState {
  final String message;
  const PrayerTimesScreenError(this.message);
  @override
  List<Object?> get props => [message];
}

class PrayerTimesScreenCubit extends Cubit<PrayerTimesScreenState> {
  final GetTodayPrayerTimesUsecase getTodayPrayerTimes;

  PrayerTimesScreenCubit({required this.getTodayPrayerTimes})
      : super(const PrayerTimesScreenLoading());

  Future<void> load() async {
    emit(const PrayerTimesScreenLoading());
    final result = await getTodayPrayerTimes();
    if (isClosed) return;
    if (result.isSuccess && result.data != null) {
      emit(PrayerTimesScreenLoaded(result.data!));
    } else {
      emit(PrayerTimesScreenError(result.message ?? 'حاول مرة اخرى'));
    }
  }
}
