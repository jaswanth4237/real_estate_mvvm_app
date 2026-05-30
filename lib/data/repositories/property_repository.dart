import 'package:shared_preferences/shared_preferences.dart';
import '../../core/utils/result.dart';
import '../../core/error/failures.dart';
import '../../core/constants.dart';
import '../../domain/repositories/i_property_repository.dart';
import '../../domain/interfaces/i_local_property_data_source.dart';
import '../../domain/interfaces/i_property_api_client.dart';
import '../models/property_model.dart';

/// Implementation of [IPropertyRepository] managing remote and local data.
class PropertyRepository implements IPropertyRepository {
  final IPropertyApiClient remoteDataSource;
  final ILocalPropertyDataSource localDataSource;
  final SharedPreferences sharedPreferences;

  PropertyRepository({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.sharedPreferences,
  });

  @override
  Future<Result<List<PropertyModel>>> fetchProperties({int page = 1}) async {
    try {
      final properties = await remoteDataSource.fetchProperties(page: page);
      await cacheProperties(properties);
      
      // Update sync timestamp
      await sharedPreferences.setString(
        AppConstants.keyLastPropertiesSyncTimestamp, 
        DateTime.now().toIso8601String()
      );
      
      return Success(properties);
    } catch (e) {
      final cached = await localDataSource.getProperties();
      if (cached.isNotEmpty) {
        return Success(cached);
      }
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<PropertyModel>> getPropertyDetails(int id) async {
    try {
      final property = await remoteDataSource.getPropertyDetails(id);
      return Success(property);
    } catch (e) {
      final cached = await localDataSource.getPropertyById(id);
      if (cached != null) {
        return Success(cached);
      }
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<PropertyModel>>> getCachedProperties() async {
    try {
      final properties = await localDataSource.getProperties();
      return Success(properties);
    } catch (e) {
      return FailureResult(CacheFailure());
    }
  }

  @override
  Future<void> cacheProperties(List<PropertyModel> properties) async {
    await localDataSource.insertProperties(properties);
  }
}
