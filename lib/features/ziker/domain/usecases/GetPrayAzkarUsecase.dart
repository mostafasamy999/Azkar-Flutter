
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/Ziker.dart';
import '../repositories/ZikerRepository.dart';

class GetPrayAzkarUseCase {
  final ZikerRepository repository;

  GetPrayAzkarUseCase(this.repository);

  Future<Either<Failure, List<Ziker>>> call() async {
    return await repository.getPrayZikerList();
  }
}
