import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:real_estate_mvvm_app/core/utils/result.dart';
import 'package:real_estate_mvvm_app/data/models/property_model.dart';
import 'package:real_estate_mvvm_app/data/repositories/property_repository.dart';
import 'package:real_estate_mvvm_app/domain/usecases/get_properties_usecase.dart';

class MockPropertyRepository extends Mock implements PropertyRepository {}

void main() {
  late GetPropertiesUseCase useCase;
  late MockPropertyRepository mockRepository;

  setUp(() {
    mockRepository = MockPropertyRepository();
    useCase = GetPropertiesUseCase(mockRepository);
  });

  final tProperties = [
    PropertyModel(
      propertyId: 1,
      title: 'Test',
      description: 'Desc',
      price: 100000,
      bedrooms: 3,
      imageUrl: 'http://image.com',
      propertyType: 'House',
    )
  ];

  test('should get properties from repository', () async {
    // arrange
    when(() => mockRepository.fetchProperties(page: 1))
        .thenAnswer((_) async => Success(tProperties));

    // act
    final result = await useCase.execute(page: 1);

    // assert
    expect(result, isA<Success<List<PropertyModel>>>());
    expect(result.data, tProperties);
    verify(() => mockRepository.fetchProperties(page: 1)).called(1);
  });
}
