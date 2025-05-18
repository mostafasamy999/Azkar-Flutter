import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/error/failures.dart';
import '../../../../../../core/strings/failures.dart';
import '../../../../../../core/strings/messages.dart';
import '../../../../domain/entities/Setting.dart';
import '../../../../domain/usecases/GetOldSettingUsecase.dart';
import '../../../../domain/usecases/SetNewSettingUsecase.dart';

part 'SettingEvent.dart';

part 'SettingState.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  final GetOldSettingUsecase getSettingUsecase;
  final UpdateSettingUsecase updateSettingUsecase;

  SettingBloc({
    required this.getSettingUsecase,
    required this.updateSettingUsecase,
  }) : super(SettingInitial()) {
    on<SettingEvent>((event, emit) async {
      if (event is GetOldSettingEvent) {
        emit(LoadingSettingState());
        final failureOrPosts = await getSettingUsecase();
        emit(_mapFailureOrSettingToState(failureOrPosts));
      } else if (event is UpdateSettingEvent) {
        emit(LoadingSettingState());
        final failureOrDoneMessage = await updateSettingUsecase(event.setting);
        emit(
          _eitherDoneMessageOrErrorState(
              failureOrDoneMessage, UPDATE_SUCCESS_MESSAGE),
        );
      }
    });
  }

  SettingState _eitherDoneMessageOrErrorState(
      Either<Failure, Unit> either, String message) {
    return either.fold(
          (failure) => ErrorSettingState(
        message: _mapFailureToMessage(failure),
      ),
          (_) => MessageUpdateSettingState(message: message),
    );
  }

  SettingState _mapFailureOrSettingToState(Either<Failure, Setting> either) {
    return either.fold(
          (failure) => ErrorSettingState(message: _mapFailureToMessage(failure)),
          (result) => LoadedSettingState(
        setting: result,
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