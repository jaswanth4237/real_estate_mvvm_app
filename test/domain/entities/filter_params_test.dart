import 'package:flutter_test/flutter_test.dart';
import 'package:real_estate_mvvm_app/domain/entities/filter_params.dart';

void main() {
  final tParams = FilterParams(
    minPrice: 100,
    maxPrice: 1000,
    bedrooms: 2,
    propertyType: 'House',
  );

  test('should support copyWith', () {
    final result = tParams.copyWith(bedrooms: 4);
    expect(result.bedrooms, 4);
    expect(result.minPrice, 100);
  });

  test('should support fromJson and toJson', () {
    final json = tParams.toJson();
    final result = FilterParams.fromJson(json);
    expect(result.minPrice, 100);
    expect(result.bedrooms, 2);
  });
}
