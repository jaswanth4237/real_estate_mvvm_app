import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/filter_params.dart';
import '../../domain/interfaces/i_filter_persistence_service.dart';
import '../constants.dart';

/// SharedPreferences-backed implementation of [IFilterPersistenceService].
///
/// Serialises [FilterParams] to JSON and persists it under
/// [AppConstants.keyActivePropertyFilters] so filters survive app restarts.
class FilterPersistenceService implements IFilterPersistenceService {
  /// The SharedPreferences instance used for persistence.
  final SharedPreferences prefs;

  /// Creates a [FilterPersistenceService] backed by [prefs].
  FilterPersistenceService(this.prefs);

  @override
  Future<void> saveFilters(FilterParams filters) async {
    await prefs.setString(
      AppConstants.keyActivePropertyFilters,
      json.encode(filters.toJson()),
    );
  }

  @override
  FilterParams? getFilters() {
    final data = prefs.getString(AppConstants.keyActivePropertyFilters);
    if (data != null) {
      return FilterParams.fromJson(
        json.decode(data) as Map<String, dynamic>,
      );
    }
    return null;
  }
}
