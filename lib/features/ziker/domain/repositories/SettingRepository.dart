

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/Setting.dart';

abstract class SettingRepository {
  Future<Either<Failure, Setting>> getOldSetting();
  Future<Either<Failure, Unit>> updateSetting(Setting s);
}