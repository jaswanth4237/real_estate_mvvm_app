import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/filter_params.dart';

class FilterPersistenceService {
  final SharedPreferences prefs;
  static const String _key = 'active_property_filters';

  FilterPersistenceService(this.prefs);

  Future<void> saveFilters(FilterParams filters) async {
    await prefs.setString(_key, json.encode(filters.toJson()));
  }

  FilterParams? getFilters() {
    final data = prefs.getString(_key);
    if (data != null) {
      return FilterParams.fromJson(json.decode(data));
    }
    return null;
  }
}
