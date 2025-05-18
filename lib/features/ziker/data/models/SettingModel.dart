import 'package:flutter/material.dart';

import '../../../../core/utils/FontSize.dart';
import '../../domain/entities/Setting.dart';

class SettingResponse extends Setting {
  SettingResponse(
      {required FontSize fontSize,
      required bool noisy,
      required bool vibrate,
      required bool transfer,
      required TimeOfDay walkUp,
      required bool isWalkUp,
      required TimeOfDay sleep,
      required bool isSleep,
      required TimeOfDay morning,
      required bool isMorning,
      required TimeOfDay evening,
      required bool isEvening,
      required TimeOfDay fager,
      required bool isFager,
      required TimeOfDay duher,
      required bool isDuher,
      required TimeOfDay aser,
      required bool isAser,
      required TimeOfDay magrep,
      required bool isMagrep,
      required TimeOfDay isha,
      required bool isIsha
      })
      : super(
            fontSize: fontSize,
            noisy: noisy,
            vibrate: vibrate,
            transfer: transfer,
            walkUp: walkUp,
            isWalkUp: isWalkUp,
            sleep: sleep,
            isSleep: isSleep,
            morning: morning,
            isMorning: isMorning,
            evening: evening,
            isEvening: isEvening,
            fager: fager,
            isFager: isFager,
            duher: duher,
            isDuher: isDuher,
            aser: aser,
            isAser: isAser,
            magrep: magrep,
            isMagrep: isMagrep,
            isha: isha,
            isIsha: isIsha
  );

  @override
  factory SettingResponse.fromJson(Map<String, dynamic> json) {
    return SettingResponse(
      fontSize: _retrieveFont(json['fontSize']),
      noisy: json['noisy'],
      vibrate: json['vibrate'],
      transfer: json['transfer'],
      walkUp: _retrieveTimeOfDay(json['walkUp']),
      isWalkUp: json['isWalkUp'],
      sleep: _retrieveTimeOfDay(json['sleep']),
      isSleep: json['isSleep'],
      morning: _retrieveTimeOfDay(json['morning']),
      isMorning: json['isMorning'],
      evening: _retrieveTimeOfDay(json['evening']),
      isEvening: json['isEvening'],
      fager: _retrieveTimeOfDay(json['fager']),
      isFager: json['isFager'],
      duher: _retrieveTimeOfDay(json['duher']),
      isDuher: json['isDuher'],
      aser: _retrieveTimeOfDay(json['aser']),
      isAser: json['isAser'],
      magrep: _retrieveTimeOfDay(json['magrep']),
      isMagrep: json['isMagrep'],
      isha: _retrieveTimeOfDay(json['isha']),
      isIsha: json['isIsha'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'fontSize': _storeFont(fontSize),
      'noisy': noisy,
      'vibrate': vibrate,
      'transfer': transfer,
      'walkUp': _storeTimeOfDay(walkUp),
      'isWalkUp': isWalkUp,
      'sleep': _storeTimeOfDay(sleep),
      'isSleep': isSleep,
      'morning': _storeTimeOfDay(morning),
      'isMorning': isMorning,
      'evening': _storeTimeOfDay(evening),
      'isEvening': isEvening,
      'fager': _storeTimeOfDay(fager),
      'isFager': isFager,
      'duher': _storeTimeOfDay(duher),
      'isDuher': isDuher,
      'aser': _storeTimeOfDay(aser),
      'isAser': isAser,
      'magrep': _storeTimeOfDay(magrep),
      'isMagrep': isMagrep,
      'isha': _storeTimeOfDay(isha),
      'isIsha': isIsha,
    };
  }


  int _storeFont(FontSize fontSize) {
    switch (fontSize) {
      case FontSize.Small:
        return 1;
      case FontSize.Median:
        return 2;
      case FontSize.Large:
        return 3;
    }
  }

  static FontSize _retrieveFont(int i) {
    switch (i) {
      case 1:
        return FontSize.Small;
      case 2:
        return FontSize.Median;
    }
    return FontSize.Large;
  }

  Map<String, int> _storeTimeOfDay(TimeOfDay time) {
    return {
      'hour': time.hour,
      'minute': time.minute,
    };
  }

  static TimeOfDay _retrieveTimeOfDay(Map<String, dynamic> json) {
    return TimeOfDay(hour: json['hour'], minute: json['minute']);
  }
}
