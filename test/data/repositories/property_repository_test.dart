import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:real_estate_mvvm_app/core/utils/result.dart';
import 'package:real_estate_mvvm_app/data/datasources/local/property_database.dart';
import 'package:real_estate_mvvm_app/data/datasources/remote/property_api_client.dart';
import 'package:real_estate_mvvm_app/data/models/property_model.dart';
import 'package:real_estate_mvvm_app/data/repositories/property_repository.dart';

class MockRemoteDataSource extends Mock implements PropertyApiClient {}
class MockLocalDataSource extends Mock implements LocalPropertyDataSource {}
class MockSharedPreferences extends Mock implements SharedPreferences {}

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

  late PropertyRepository repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockSharedPreferences = MockSharedPreferences();
    repository = PropertyRepository(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      sharedPreferences: mockSharedPreferences,
    );
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

  test('should return remote data when call to remote is successful', () async {
    // arrange
    when(() => mockRemoteDataSource.fetchProperties(page: 1))
        .thenAnswer((_) async => tProperties);
    when(() => mockLocalDataSource.insertProperties(any()))
        .thenAnswer((_) async => Future.value());
    when(() => mockSharedPreferences.setString(any(), any()))
        .thenAnswer((_) async => true);

    // act
    final result = await repository.fetchProperties(page: 1);

    // assert
    expect(result, isA<Success<List<PropertyModel>>>());
    expect(result.data, tProperties);
    verify(() => mockRemoteDataSource.fetchProperties(page: 1)).called(1);
  });

  test('should return cached data when remote fetch fails', () async {
    // arrange
    when(() => mockRemoteDataSource.fetchProperties(page: 1))
        .thenThrow(Exception('No internet'));
    when(() => mockLocalDataSource.getProperties())
        .thenAnswer((_) async => tProperties);

    // act
    final result = await repository.fetchProperties(page: 1);

    // assert
    expect(result, isA<Success<List<PropertyModel>>>());
    expect(result.data, tProperties);
  });

  test('should return property details when call is successful', () async {
    // arrange
    final tProperty = tProperties.first;
    when(() => mockRemoteDataSource.getPropertyDetails(1))
        .thenAnswer((_) async => tProperty);

    // act
    final result = await repository.getPropertyDetails(1);

    // assert
    expect(result, isA<Success<PropertyModel>>());
    expect(result.data, tProperty);
  });
}
