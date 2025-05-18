import 'dart:ffi';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/FontSize.dart';

class Setting extends Equatable {
  FontSize fontSize;
  bool noisy;
  bool vibrate;
  bool transfer;
  TimeOfDay walkUp;
  bool isWalkUp;
  TimeOfDay sleep;
  bool isSleep;
  TimeOfDay morning;
  bool isMorning;
  TimeOfDay evening;
  bool isEvening;
  TimeOfDay fager;
  bool isFager;
  TimeOfDay duher;
  bool isDuher;
  TimeOfDay aser;
  bool isAser;
  TimeOfDay magrep;
  bool isMagrep;
  TimeOfDay isha;
  bool isIsha;

  Setting({
    required this.fontSize,
    required this.noisy,
    required this.vibrate,
    required this.transfer,
    required this.walkUp,
    required this.isWalkUp,
    required this.sleep,
    required this.isSleep,
    required this.morning,
    required this.isMorning,
    required this.evening,
    required this.isEvening,
    required this.fager,
    required this.isFager,
    required this.duher,
    required this.isDuher,
    required this.aser,
    required this.isAser,
    required this.magrep,
    required this.isMagrep,
    required this.isha,
    required this.isIsha,
  });

  @override
  List<Object?> get props => [
        fontSize,
        noisy,
        vibrate,
        transfer,
        walkUp,
        isWalkUp,
        sleep,
        isSleep,
        morning,
        isMorning,
        evening,
        isEvening,
        fager,
        isFager,
        duher,
        isDuher,
        aser,
        isAser,
        magrep,
        isMagrep,
        isha,
        isIsha
      ];
}
