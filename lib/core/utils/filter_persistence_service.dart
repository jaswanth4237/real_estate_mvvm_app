import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/filter_params.dart';
import '../../domain/interfaces/i_filter_persistence_service.dart';
import '../constants.dart';

class FilterPersistenceService implements IFilterPersistenceService {
  final SharedPreferences prefs;

  FilterPersistenceService(this.prefs);

  @override
  Future<void> saveFilters(FilterParams filters) async {
    await prefs.setString(AppConstants.keyActivePropertyFilters, json.encode(filters.toJson()));
  }

  @override
  FilterParams? getFilters() {
    final data = prefs.getString(AppConstants.keyActivePropertyFilters);
    if (data != null) {
      return FilterParams.fromJson(json.decode(data));
    }
    return null;
  }
}
