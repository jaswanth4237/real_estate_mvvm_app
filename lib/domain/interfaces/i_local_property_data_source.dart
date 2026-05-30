import '../../data/models/property_model.dart';

/// Contract for the local Hive-backed property data source.
///
/// Provides offline storage for properties, favourites, and search history
/// across three separate Hive boxes to avoid data conflicts.
abstract class ILocalPropertyDataSource {
  /// Opens the required Hive boxes. Must be called once before any other method.
  Future<void> init();

  /// Upserts all [properties] into the properties Hive box.
  Future<void> insertProperties(List<PropertyModel> properties);

  /// Returns all properties stored in the properties Hive box.
  Future<List<PropertyModel>> getProperties();

  /// Returns the cached property with [id], or `null` if not found.
  Future<PropertyModel?> getPropertyById(int id);

  /// Removes all entries from the properties Hive box.
  Future<void> clearCache();

  /// Toggles the favourite state of [property] in the favourites Hive box.
  Future<void> toggleFavorite(PropertyModel property);

  /// Returns all properties currently marked as favourites.
  Future<List<PropertyModel>> getFavorites();

  /// Appends [query] to the search-history Hive box.
  Future<void> addSearchQuery(String query);

  /// Returns the full search-history list in insertion order.
  Future<List<String>> getSearchHistory();
}
