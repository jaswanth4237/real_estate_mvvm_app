import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:real_estate_mvvm_app/data/datasources/remote/property_api_client.dart';
import 'package:real_estate_mvvm_app/data/models/property_model.dart';

class MockDio extends Mock implements Dio {}
class MockResponse extends Mock implements Response {}

void main() {
  late PropertyApiClient client;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    // For the constructor interceptors
    when(() => mockDio.options).thenReturn(BaseOptions());
    when(() => mockDio.interceptors).thenReturn(Interceptors());
    client = PropertyApiClient(mockDio);
  });

  test('fetchProperties returns list of properties on 200', () async {
    final response = MockResponse();
    when(() => response.statusCode).thenReturn(200);
    when(() => response.data).thenReturn([
      {'id': 1, 'title': 'Test', 'body': 'Desc'}
    ]);
    when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
        .thenAnswer((_) async => response);

    final result = await client.fetchProperties();

    expect(result.first.propertyId, 1);
  });

  test('getPropertyDetails throws exception on 404', () async {
    final response = MockResponse();
    when(() => response.statusCode).thenReturn(404);
    when(() => mockDio.get(any())).thenAnswer((_) async => response);

    expect(() => client.getPropertyDetails(1), throwsException);
  });
}
