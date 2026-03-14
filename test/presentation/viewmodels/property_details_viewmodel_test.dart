import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:real_estate_mvvm_app/core/utils/result.dart';
import 'package:real_estate_mvvm_app/data/datasources/local/property_database.dart';
import 'package:real_estate_mvvm_app/core/error/failures.dart';
import 'package:real_estate_mvvm_app/data/models/property_model.dart';
import 'package:real_estate_mvvm_app/domain/usecases/get_property_details_usecase.dart';
import 'package:real_estate_mvvm_app/presentation/viewmodels/property_details_viewmodel.dart';

class MockGetPropertyDetailsUseCase extends Mock implements GetPropertyDetailsUseCase {}
class MockLocalPropertyDataSource extends Mock implements LocalPropertyDataSource {}

void main() {
  setUpAll(() {
    registerFallbackValue(PropertyModel(
      propertyId: 0,
      title: '',
      description: '',
      price: 0,
      bedrooms: 0,
      imageUrl: '',
      propertyType: '',
    ));
  });

  late PropertyDetailsViewModel viewModel;
  late MockGetPropertyDetailsUseCase mockUseCase;
  late MockLocalPropertyDataSource mockDataSource;

  setUp(() {
    mockUseCase = MockGetPropertyDetailsUseCase();
    mockDataSource = MockLocalPropertyDataSource();
    viewModel = PropertyDetailsViewModel(
      getPropertyDetailsUseCase: mockUseCase,
      localDataSource: mockDataSource,
    );
  });

  final tProperty = PropertyModel(
    propertyId: 1,
    title: 'Test',
    description: 'Desc',
    price: 100000,
    bedrooms: 3,
    imageUrl: 'http://image.com',
    propertyType: 'House',
  );

  test('should load property details successfully', () async {
    // arrange
    when(() => mockUseCase.execute(1))
        .thenAnswer((_) async => Success(tProperty));

    // act
    await viewModel.loadPropertyDetails(1);

    // assert
    expect(viewModel.property, tProperty);
    expect(viewModel.isLoading, false);
    expect(viewModel.errorMessage, isNull);
  });

  test('should toggle favorite status', () async {
    // arrange
    when(() => mockUseCase.execute(1))
        .thenAnswer((_) async => Success(tProperty));
    when(() => mockDataSource.toggleFavorite(any()))
        .thenAnswer((_) async => Future.value());

    // act
    await viewModel.loadPropertyDetails(1);
    await viewModel.toggleFavorite();

    // assert
    expect(viewModel.property!.isFavorite, true);
    verify(() => mockDataSource.toggleFavorite(any())).called(1);
  });

  test('should set error message when loading fails', () async {
    // arrange
    when(() => mockUseCase.execute(1))
        .thenAnswer((_) async => FailureResult(ServerFailure('API Error')));

    // act
    await viewModel.loadPropertyDetails(1);

    // assert
    expect(viewModel.errorMessage, 'API Error');
    expect(viewModel.isLoading, false);
  });
}
