import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahih_azkar/features/ziker/domain/usecases/GetPrayAzkarUsecase.dart';
import '../../../../../../core/error/failures.dart';
import '../../../../../../core/strings/failures.dart';
import '../../../../domain/entities/Ziker.dart';
import '../../../../domain/usecases/GetAzkarWithoutPrayUsecase.dart';

part 'AzkarTitlesEvent.dart';

part 'AzkarTitlesState.dart';

class AzkarBloc extends Bloc<AzkarTitlesEvent, AzkarState> {

  final GetZikerListWithoutPrayUseCase getZikerListWithoutPrayUseCase;
  final GetPrayAzkarUseCase getPrayAzkarUseCase;

  AzkarBloc({
    required this.getZikerListWithoutPrayUseCase,
    required this.getPrayAzkarUseCase,
  }) : super(AzkarInitial()) {
    on<AzkarTitlesEvent>((event, emit) async {
      if (event is GetAllAzkarTitlesEvent) {
        emit(LoadingAzkarState());
        final failureOrPosts1 = await getZikerListWithoutPrayUseCase();
        print('normal azkar : ${failureOrPosts1}');
        final failureOrPosts2 = await getPrayAzkarUseCase();
        emit(_mapFailureOrAzkarToStateCorrected(failureOrPosts1, failureOrPosts2));
      }
    });
  }

  AzkarState _mapFailureOrAzkarToStateCorrected(
      Either<Failure, List<Ziker>> zikerWithoutPray,
      Either<Failure, List<Ziker>> prayZiker,
      ) {
    return zikerWithoutPray.fold(
          (failure1) => ErrorAzkarState(message: _mapFailureToMessage(failure1)),
          (azkarWithoutPrayList) => prayZiker.fold(
            (failure2) => ErrorAzkarState(message: _mapFailureToMessage(failure2)),
            (prayZikerList) => LoadedAzkarState(
          azkarWithoutPray: azkarWithoutPrayList,
          pryaAzkar: prayZikerList,
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