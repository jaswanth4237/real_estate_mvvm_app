import 'package:hive_flutter/hive_flutter.dart';
import '../../models/property_model.dart';

class LocalPropertyDataSource {
  static const String propertiesBoxName = 'properties';
  static const String favoritesBoxName = 'favorites';
  static const String searchHistoryBoxName = 'search_history';

  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(propertiesBoxName);
    await Hive.openBox(favoritesBoxName);
    await Hive.openBox(searchHistoryBoxName);
  }

  Future<void> insertProperties(List<PropertyModel> properties) async {
    final box = Hive.box(propertiesBoxName);
    final Map<int, dynamic> data = {
      for (var p in properties) p.propertyId: p.toJson()
    };
    await box.putAll(data);
  }

  Future<List<PropertyModel>> getProperties() async {
    final box = Hive.box(propertiesBoxName);
    return box.values
        .map((e) => PropertyModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<PropertyModel?> getPropertyById(int id) async {
    final box = Hive.box(propertiesBoxName);
    final data = box.get(id);
    if (data != null) {
      return PropertyModel.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }

  Future<void> clearCache() async {
    await Hive.box(propertiesBoxName).clear();
  }

  // Favorites
  Future<void> toggleFavorite(PropertyModel property) async {
    final box = Hive.box(favoritesBoxName);
    if (box.containsKey(property.propertyId)) {
      await box.delete(property.propertyId);
    } else {
      await box.put(property.propertyId, property.toJson());
    }
  }

  Future<List<PropertyModel>> getFavorites() async {
    final box = Hive.box(favoritesBoxName);
    return box.values
        .map((e) => PropertyModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  // Search History
  Future<void> addSearchQuery(String query) async {
    final box = Hive.box(searchHistoryBoxName);
    await box.add(query);
  }

  Future<List<String>> getSearchHistory() async {
    final box = Hive.box(searchHistoryBoxName);
    return box.values.cast<String>().toList();
  }
}
