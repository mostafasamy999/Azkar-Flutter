
import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/Ziker.dart';
import '../../domain/repositories/ZikerRepository.dart';
import '../datasources/ZikerLocalDataSource.dart';


class Zikerrepositoryimpl implements ZikerRepository {
  final ZikerLocalDataSource zikerDataSource;

  Zikerrepositoryimpl(
      {
        required this.zikerDataSource,
       });

  @override
  Future<Either<Failure, List<Ziker>>> getZikerListWithoutPray()  async {
      try {
        final localPosts = await zikerDataSource.getZikerListWithoutPrayHaijOmra();
        return Right(localPosts);
      } on EmptyCacheException {
        return Left(EmptyCacheFailure());
      }
  }
  @override
  Future<Either<Failure, List<Ziker>>> getPrayZikerList()  async {
      try {
        final localPosts = await zikerDataSource.getPrayZikerList();
        return Right(localPosts);
      } on EmptyCacheException {
        return Left(EmptyCacheFailure());
      }
  }
  @override
  Future<Either<Failure, List<Ziker>>> getHaijZikerList()  async {
      try {
        final localPosts = await zikerDataSource.getHaijZikerList();
        return Right(localPosts);
      } on EmptyCacheException {
        return Left(EmptyCacheFailure());
      }
  }
  @override
  Future<Either<Failure, List<Ziker>>> getOmraZikerList()  async {
      try {
        final localPosts = await zikerDataSource.getOmraZikerList();
        return Right(localPosts);
      } on EmptyCacheException {
        return Left(EmptyCacheFailure());
      }
  }

}
