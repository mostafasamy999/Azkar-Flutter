import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/Setting.dart';
import '../../domain/repositories/SettingRepository.dart';
import '../datasources/SettingDataSorce.dart';
import '../models/SettingModel.dart';

class SettingRepositoryImpl implements SettingRepository {
  final SettingDataSource settingDataSource;

  SettingRepositoryImpl({
    required this.settingDataSource,
  });

  @override
  Future<Either<Failure, SettingResponse>> getOldSetting() async {
    try {
      final localPosts = await settingDataSource.getOldSetting();
      return Right(localPosts as SettingResponse);
    } on EmptyCacheException {
      return Left(EmptyCacheFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateSetting(Setting setting) async {
    try {
      await settingDataSource.updateSetting(SettingResponse(
        fontSize: setting.fontSize,
        noisy: setting.noisy,
        vibrate: setting.vibrate,
        transfer: setting.transfer,
        walkUp: setting.walkUp,
        isWalkUp: setting.isWalkUp,
        sleep: setting.sleep,
        isSleep: setting.isSleep,
        morning: setting.morning,
        isMorning: setting.isMorning,
        evening: setting.evening,
        isEvening: setting.isEvening,
        fager: setting.fager,
        isFager: setting.isFager,
        duher: setting.duher,
        isDuher: setting.isDuher,
        aser: setting.aser,
        isAser: setting.isAser,
        magrep: setting.magrep,
        isMagrep: setting.isMagrep,
        isha: setting.isha,
        isIsha: setting.isIsha,
      ));
      return Right(unit);
    } catch (e) {
      print('repo e: ${e.toString()}');
      return Left(UnKnownFailure(message: e.toString()));
    }
  }
}
