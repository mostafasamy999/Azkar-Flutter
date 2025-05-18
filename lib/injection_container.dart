import 'package:get_it/get_it.dart';
import 'package:sahih_azkar/features/ziker/domain/usecases/GetPrayAzkarUsecase.dart';

import 'features/ziker/data/datasources/PrayerTimesDataSource.dart';
import 'features/ziker/data/datasources/SettingDataSorce.dart';
import 'features/ziker/data/datasources/ZikerLocalDataSource.dart';
import 'features/ziker/data/repositories/PrayerTimeRepositoryImpl.dart';
import 'features/ziker/data/repositories/SettingRepositoryImpl.dart';
import 'features/ziker/data/repositories/ZikerRepositoryImpl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/ziker/domain/repositories/PrayerTimeRepository.dart';
import 'features/ziker/domain/repositories/SettingRepository.dart';
import 'features/ziker/domain/repositories/ZikerRepository.dart';
import 'features/ziker/domain/usecases/GetAzkarWithoutPrayUsecase.dart';
import 'features/ziker/domain/usecases/GetOldSettingUsecase.dart';
import 'features/ziker/domain/usecases/GetPrayerTimesUsecase.dart';
import 'features/ziker/domain/usecases/SetNewSettingUsecase.dart';
import 'features/ziker/presentation/bloc/PrayerTime/PrayerTimeCubit.dart';
import 'features/ziker/presentation/bloc/azkar/azkar/AzkarBloc.dart';
import 'package:http/http.dart' as http;

import 'features/ziker/presentation/bloc/azkar/setting/SettingBloc.dart';

final sl = GetIt.instance;

Future<void> init() async {

  // Bloc
  sl.registerFactory(() => AzkarBloc(getZikerListWithoutPrayUseCase: sl(),getPrayAzkarUseCase: sl()));
  sl.registerFactory(() => SettingBloc(getSettingUsecase: sl(), updateSettingUsecase: sl()));
  sl.registerFactory(() => PrayerTimesCubit(  getPrayerTimesUsecase: sl()));

  // Usecases
  sl.registerLazySingleton(() => GetPrayAzkarUseCase(sl()));
  sl.registerLazySingleton(() => GetZikerListWithoutPrayUseCase(sl()));
  sl.registerLazySingleton(() => GetOldSettingUsecase(sl()));
  sl.registerLazySingleton(() => UpdateSettingUsecase(sl()));
  sl.registerLazySingleton(() => GetPrayerTimesUsecase(sl()));

  // Repository
  sl.registerLazySingleton<ZikerRepository>(() => Zikerrepositoryimpl( zikerDataSource: sl()));
  sl.registerLazySingleton<SettingRepository>(() => SettingRepositoryImpl(settingDataSource: sl()));
  sl.registerLazySingleton<PrayerTimeRepository>(() => PrayerTimeRepositoryImpl(remoteDataSource: sl()));

  // Datasources
  sl.registerLazySingleton<ZikerLocalDataSource>(
          () => ZikerLocalDataSourceImpl());
  sl.registerLazySingleton<SettingDataSource>(
          () => SettingDataSourceImpl(sharedPreferences: sl()));
  sl.registerLazySingleton<PrayerTimesRemoteDataSource>(
          () => PrayerTimesRemoteDataSourceImpl(client: sl()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
}