import 'package:flutter_test/flutter_test.dart';
import 'package:real_estate_mvvm_app/data/models/property_model.dart';

void main() {
  final tModel = PropertyModel(
    propertyId: 1,
    title: 'Test',
    description: 'Desc',
    price: 100000,
    bedrooms: 2,
    imageUrl: 'http://image.com',
    propertyType: 'House',
  );

  test('should support copyWith', () {
    final result = tModel.copyWith(isFavorite: true);
    expect(result.isFavorite, true);
    expect(result.propertyId, 1);
  });

  test('should support fromJson and toJson', () {
    final json = tModel.toJson();
    final result = PropertyModel.fromJson(json);
    expect(result.propertyId, 1);
    expect(result.title, 'Test');
    expect(result.description, 'Desc');
    expect(result.price, 100000);
    expect(result.bedrooms, 2);
    expect(result.imageUrl, 'http://image.com');
    expect(result.propertyType, 'House');
    expect(result.isFavorite, false);
  });
}
