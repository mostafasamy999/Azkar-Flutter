import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/tasbeeh/TasbeehCubit.dart';
import '../../bloc/tasbeeh/TasbeehState.dart';
import 'TasbeehCounterButton.dart';

class TasbeehContent extends StatelessWidget {
  const TasbeehContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocSelector<TasbeehCubit, TasbeehState, int>(
        selector: (state) => state.count,
        builder: (context, count) => TasbeehCounterButton(count: count),
      ),
    );
  }
}
