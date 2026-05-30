import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:real_estate_mvvm_app/core/utils/result.dart';
import 'package:real_estate_mvvm_app/data/models/property_model.dart';
import 'package:real_estate_mvvm_app/domain/repositories/i_property_repository.dart';
import 'package:real_estate_mvvm_app/domain/usecases/get_property_details_usecase.dart';

class MockPropertyRepository extends Mock implements IPropertyRepository {}

void main() {
  late GetPropertyDetailsUseCase useCase;
  late MockPropertyRepository mockRepository;

  setUp(() {
    mockRepository = MockPropertyRepository();
    useCase = GetPropertyDetailsUseCase(mockRepository);
  });

  final tProperty = PropertyModel(
    propertyId: 1,
    title: 'Test',
    description: 'Desc',
    price: 100000,
    bedrooms: 2,
    bathrooms: 2,
    squareFootage: 1200,
    imageUrl: 'http://image.com',
    propertyType: 'House',
  );

  test('should get property details from repository', () async {
    // arrange
    when(() => mockRepository.getPropertyDetails(1))
        .thenAnswer((_) async => Success(tProperty));

    // act
    final result = await useCase.execute(1);

    // assert
    expect(result, isA<Success<PropertyModel>>());
    expect(result.data, tProperty);
    verify(() => mockRepository.getPropertyDetails(1)).called(1);
  });
}
