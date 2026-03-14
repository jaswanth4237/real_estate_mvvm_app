import 'package:shared_preferences/shared_preferences.dart';
import '../../core/utils/result.dart';
import '../../core/error/failures.dart';
import '../datasources/local/property_database.dart';
import '../datasources/remote/property_api_client.dart';
import '../models/property_model.dart';

/// Interface for property data operations.
abstract class IPropertyRepository {
  /// Fetches a list of properties from the remote or local data source.
  Future<Result<List<PropertyModel>>> fetchProperties({int page = 1});
  
  /// Retrieves details for a specific property by its ID.
  Future<Result<PropertyModel>> getPropertyDetails(int id);
  
  /// Gets properties that are currently stored in the local cache.
  Future<Result<List<PropertyModel>>> getCachedProperties();
  
  /// Caches a list of properties to the local database.
  Future<void> cacheProperties(List<PropertyModel> properties);
}

/// Implementation of [IPropertyRepository] managing remote and local data.
class PropertyRepository implements IPropertyRepository {
  final PropertyApiClient remoteDataSource;
  final LocalPropertyDataSource localDataSource;
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
        'last_properties_sync_timestamp', 
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
