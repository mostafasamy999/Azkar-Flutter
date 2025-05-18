

import '../entities/Setting.dart';
import '../repositories/SettingRepository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

class UpdateSettingUsecase {
  final SettingRepository repository;

  UpdateSettingUsecase(this.repository);

  Future<Either<Failure, Unit>> call(Setting setting) async {
    return await repository.updateSetting(setting);
  }
}