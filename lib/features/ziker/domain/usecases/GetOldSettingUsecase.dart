

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/Setting.dart';
import '../repositories/SettingRepository.dart';

class GetOldSettingUsecase {
  final SettingRepository repository;

  GetOldSettingUsecase(this.repository);

  Future<Either<Failure, Setting>> call() async {
    return await repository.getOldSetting();
  }
}