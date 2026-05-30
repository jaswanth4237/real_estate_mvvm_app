import '../entities/filter_params.dart';

/// Contract for persisting and retrieving active property filter settings.
///
/// Implementations store serialised [FilterParams] in SharedPreferences so
/// that active filters survive app restarts.
abstract class IFilterPersistenceService {
  /// Serialises and saves [filters] to persistent storage.
  Future<void> saveFilters(FilterParams filters);

  /// Returns the last-saved [FilterParams], or `null` if none exist.
  FilterParams? getFilters();
}
