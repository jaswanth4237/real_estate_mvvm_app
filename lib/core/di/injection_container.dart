import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/datasources/local/property_database.dart';
import '../../data/datasources/remote/property_api_client.dart';
import '../../data/repositories/property_repository.dart';
import '../../domain/usecases/get_properties_usecase.dart';
import '../../domain/usecases/get_property_details_usecase.dart';
import '../../presentation/viewmodels/property_list_viewmodel.dart';
import '../../presentation/viewmodels/property_details_viewmodel.dart';
import '../theme/app_theme.dart';
import '../feature_flags/feature_flag_service.dart';
import '../utils/filter_persistence_service.dart';
import '../di/accessibility/accessibility_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());

  // Core
  sl.registerLazySingleton(() => ThemeService(sl()));
  sl.registerLazySingleton(() => FeatureFlagService());
  sl.registerLazySingleton(() => AccessibilityService(sl()));
  sl.registerLazySingleton(() => FilterPersistenceService(sl()));

  // Data Sources
  final localDataSource = LocalPropertyDataSource();
  await localDataSource.init();
  sl.registerLazySingleton(() => localDataSource);
  sl.registerLazySingleton(() => PropertyApiClient(sl()));

  // Repository
  sl.registerLazySingleton(() => PropertyRepository(
    remoteDataSource: sl(),
    localDataSource: sl(),
    sharedPreferences: sl(),
  ));

  // Use Cases
  sl.registerFactory(() => GetPropertiesUseCase(sl()));
  sl.registerFactory(() => GetPropertyDetailsUseCase(sl()));

  // ViewModels
  sl.registerFactory(() => PropertyListViewModel(
    getPropertiesUseCase: sl(),
    filterPersistenceService: sl(),
  ));
  sl.registerFactory(() => PropertyDetailsViewModel(
    getPropertyDetailsUseCase: sl(),
    localDataSource: sl(),
  ));

  // Initialize Services
  await sl<FeatureFlagService>().init();
}
