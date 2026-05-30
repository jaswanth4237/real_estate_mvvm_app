import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/interfaces/i_local_property_data_source.dart';
import '../../domain/interfaces/i_property_api_client.dart';
import '../../domain/interfaces/i_theme_service.dart';
import '../../domain/interfaces/i_feature_flag_service.dart';
import '../../domain/interfaces/i_accessibility_service.dart';
import '../../domain/interfaces/i_filter_persistence_service.dart';
import '../../domain/repositories/i_property_repository.dart';

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
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<Dio>(() => Dio());

  // Core
  sl.registerLazySingleton<IThemeService>(() => ThemeService(sl()));
  sl.registerLazySingleton<IFeatureFlagService>(() => FeatureFlagService());
  sl.registerLazySingleton<IAccessibilityService>(() => AccessibilityService(sl()));
  sl.registerLazySingleton<IFilterPersistenceService>(() => FilterPersistenceService(sl()));

  // Data Sources
  final localDataSource = LocalPropertyDataSource();
  await localDataSource.init();
  sl.registerLazySingleton<ILocalPropertyDataSource>(() => localDataSource);
  sl.registerLazySingleton<IPropertyApiClient>(() => PropertyApiClient(sl()));

  // Repository
  sl.registerLazySingleton<IPropertyRepository>(() => PropertyRepository(
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
    repository: sl(),
  ));

  // Initialize Services
  await sl<IFeatureFlagService>().init();
}
