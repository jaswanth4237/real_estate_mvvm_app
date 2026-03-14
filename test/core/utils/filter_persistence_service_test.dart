import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:real_estate_mvvm_app/core/utils/filter_persistence_service.dart';
import 'package:real_estate_mvvm_app/domain/entities/filter_params.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late FilterPersistenceService service;
  late MockSharedPreferences mockPrefs;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    service = FilterPersistenceService(mockPrefs);
  });

  final tFilters = FilterParams(
    minPrice: 1000,
    maxPrice: 5000,
    bedrooms: 2,
    propertyType: 'House',
  );

  test('should save filters to shared preferences', () async {
    // arrange
    when(() => mockPrefs.setString(any(), any()))
        .thenAnswer((_) async => true);

    // act
    await service.saveFilters(tFilters);

    // assert
    verify(() => mockPrefs.setString('active_property_filters', any())).called(1);
  });

  test('should return filters from shared preferences', () {
    // arrange
    when(() => mockPrefs.getString('active_property_filters'))
        .thenReturn(json.encode(tFilters.toJson()));

    // act
    final result = service.getFilters();

    // assert
    expect(result!.minPrice, 1000);
    expect(result.maxPrice, 5000);
    expect(result.bedrooms, 2);
    expect(result.propertyType, 'House');
  });
}
