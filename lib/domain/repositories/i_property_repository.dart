import '../../core/utils/result.dart';
import '../../data/models/property_model.dart';

/// Contract for the property data repository.
///
/// Implementors are responsible for orchestrating remote API calls and
/// local Hive caching, providing an offline-first strategy to consumers.
abstract class IPropertyRepository {
  /// Fetches a paginated list of properties from remote; falls back to cache.
  Future<Result<List<PropertyModel>>> fetchProperties({int page = 1});

  /// Fetches full details for the property identified by [id].
  Future<Result<PropertyModel>> getPropertyDetails(int id);

  /// Returns all properties currently held in the local cache.
  Future<Result<List<PropertyModel>>> getCachedProperties();

  /// Persists the given [properties] list to the local cache.
  Future<void> cacheProperties(List<PropertyModel> properties);

  /// Toggles the favourite status of a property.
  Future<void> toggleFavorite(PropertyModel property);

  /// Returns a list of all favourite properties.
  Future<Result<List<PropertyModel>>> getFavorites();
}
