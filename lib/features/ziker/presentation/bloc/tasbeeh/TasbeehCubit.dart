import 'package:flutter_bloc/flutter_bloc.dart';

import 'TasbeehState.dart';

class TasbeehCubit extends Cubit<TasbeehState> {
  TasbeehCubit() : super(const TasbeehState());

  void increment() => emit(state.copyWith(count: state.count + 1));

  void reset() => emit(state.copyWith(count: 0));
}
