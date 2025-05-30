import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahih_azkar/features/ziker/domain/usecases/GetHaijAzkarUsecase.dart';
import 'package:sahih_azkar/features/ziker/domain/usecases/GetOmraAzkarUsecase.dart';
import 'package:sahih_azkar/features/ziker/domain/usecases/GetPrayAzkarUsecase.dart';
import '../../../../../../core/error/failures.dart';
import '../../../../../../core/strings/failures.dart';
import '../../../../domain/entities/Ziker.dart';
import '../../../../domain/usecases/GetAzkarWithoutPrayUsecase.dart';

part 'AzkarTitlesEvent.dart';
part 'AzkarTitlesState.dart';

class AzkarBloc extends Bloc<AzkarTitlesEvent, AzkarState> {

  final GetZikerListWithoutPrayUseCase getZikerListWithoutPrayHaijOmraUseCase;
  final GetPrayAzkarUseCase getPrayAzkarUseCase;
  final GetHaijAzkarUseCase getHaijAzkarUseCase;
  final GetOmraAzkarUseCase getOmraAzkarUseCase;

  AzkarBloc({
    required this.getZikerListWithoutPrayHaijOmraUseCase,
    required this.getPrayAzkarUseCase,
    required this.getOmraAzkarUseCase,
    required this.getHaijAzkarUseCase
  }) : super(AzkarInitial()) {
    on<AzkarTitlesEvent>((event, emit) async {
      if (event is GetAllAzkarTitlesEvent) {
        emit(LoadingAzkarState());

        final failureOrPosts1 = await getZikerListWithoutPrayHaijOmraUseCase();
        print('normal azkar : ${failureOrPosts1}');

        final failureOrPosts2 = await getPrayAzkarUseCase();
        print('pray azkar : ${failureOrPosts2}');

        final failureOrPosts3 = await getHaijAzkarUseCase();
        print('haij azkar : ${failureOrPosts3}');

        final failureOrPosts4 = await getOmraAzkarUseCase();
        print('omra azkar : ${failureOrPosts4}');

        emit(_mapFailureOrAzkarToStateCorrected(
            failureOrPosts1,
            failureOrPosts2,
            failureOrPosts3,
            failureOrPosts4
        ));
      }
    });
  }

  AzkarState _mapFailureOrAzkarToStateCorrected(
      Either<Failure, List<Ziker>> zikerWithoutPray,
      Either<Failure, List<Ziker>> prayZiker,
      Either<Failure, List<Ziker>> haijZiker,
      Either<Failure, List<Ziker>> omraZiker,
      ) {
    return zikerWithoutPray.fold(
          (failure1) => ErrorAzkarState(message: _mapFailureToMessage(failure1)),
          (azkarWithoutPrayList) => prayZiker.fold(
            (failure2) => ErrorAzkarState(message: _mapFailureToMessage(failure2)),
            (prayZikerList) => haijZiker.fold(
              (failure3) => ErrorAzkarState(message: _mapFailureToMessage(failure3)),
              (haijZikerList) => omraZiker.fold(
                (failure4) => ErrorAzkarState(message: _mapFailureToMessage(failure4)),
                (omraZikerList) => LoadedAzkarState(
              azkarWithoutPray: azkarWithoutPrayList,
              pryaAzkar: prayZikerList,
              haijAzkar: haijZikerList,
              omraAzkar: omraZikerList,
            ),
          ),
        ),
      ),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case EmptyCacheFailure:
        return EMPTY_CACHE_FAILURE_MESSAGE;
      case OfflineFailure:
        return OFFLINE_FAILURE_MESSAGE;
      default:
        return "Unexpected Error , Please try again later .";
    }
  }
}