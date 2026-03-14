import 'dart:convert';
import 'package:dio/dio.dart';
import 'api_interceptors.dart';
import '../../models/property_model.dart';
import '../../../../core/utils/app_data_path.dart';

class PropertyApiClient {
  final Dio _dio;
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  PropertyApiClient(this._dio) {
    _dio.options.baseUrl = baseUrl;
    _dio.interceptors.addAll([
      LoggingInterceptor(),
      ErrorHandlingInterceptor(),
    ]);
  }

  Future<List<PropertyModel>> fetchProperties({int page = 1, int limit = 10}) async {
    final response = await _dio.get('/posts', queryParameters: {
      '_page': page,
      '_limit': limit,
    });

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      
      // Cache response as JSON file
      await _cacheResponse(page, data);
      
      return data.map((json) => _mapToPropertyModel(json)).toList();
    } else {
      throw Exception('Failed to fetch properties');
    }
  }

  Future<PropertyModel> getPropertyDetails(int id) async {
    final response = await _dio.get('/posts/$id');

    if (response.statusCode == 200) {
      return _mapToPropertyModel(response.data);
    } else {
      throw Exception('Failed to fetch property details');
    }
  }

  PropertyModel _mapToPropertyModel(Map<String, dynamic> json) {
    final id = json['id'] as int;
    final types = ['Luxury Villa', 'Modern Apartment', 'Penthouse', 'Cozy Cottage', 'Family House'];
    final areas = ['Downtown', 'Suburbia', 'Riverside', 'Hillside', 'Coastal'];
    
    final type = types[id % types.length];
    final area = areas[id % areas.length];
    
    return PropertyModel(
      propertyId: id,
      title: '$type in $area',
      description: 'A stunning $type located in the heart of $area. This property features premium finishes, spacious rooms, and great accessibility to local amenities. ${json['body']}',
      price: id * 15000.0 + 150000.0,
      bedrooms: (id % 4) + 1,
      imageUrl: 'https://picsum.photos/seed/$id/800/600',
      propertyType: type,
      isFavorite: false,
    );
  }

  Future<void> _cacheResponse(int page, dynamic data) async {
    try {
      final file = await AppDataPath.getFile('api_cache/properties_page_$page.json');
      await file.writeAsString(json.encode(data));
    } catch (e) {
      print('Error caching API response: $e');
    }
  }
}
