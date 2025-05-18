
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/Ziker.dart';

abstract class ZikerRepository {
  Future<Either<Failure, List<Ziker>>> getZikerListWithoutPray();
  Future<Either<Failure, List<Ziker>>>  getPrayZikerList();
}
