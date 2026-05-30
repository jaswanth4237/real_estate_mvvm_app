import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:real_estate_mvvm_app/main.dart' as app;
import 'package:real_estate_mvvm_app/core/di/injection_container.dart' as di;
import 'package:dio/dio.dart';
import 'package:real_estate_mvvm_app/domain/interfaces/i_local_property_data_source.dart';
import 'package:real_estate_mvvm_app/data/models/property_model.dart';
import 'package:real_estate_mvvm_app/core/theme/app_theme.dart';

class MockDio extends Mock implements Dio {}
class MockLocalDataSource extends Mock implements ILocalPropertyDataSource {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Full property flow tap on a card and view details', (WidgetTester tester) async {
    final mockDio = MockDio();
    final mockLocalDb = MockLocalDataSource();

    when(() => mockLocalDb.init()).thenAnswer((_) async => {});
    when(() => mockLocalDb.getProperties()).thenAnswer((_) async => []);
    when(() => mockLocalDb.insertProperties(any())).thenAnswer((_) async => {});
    when(() => mockLocalDb.toggleFavorite(any())).thenAnswer((_) async => {});
    when(() => mockLocalDb.getPropertyById(1)).thenAnswer((_) async => 
      PropertyModel(propertyId: 1, title: 'Title', description: 'Desc', price: 100, bedrooms: 2, bathrooms: 1, squareFootage: 100, imageUrl: '', propertyType: '')
    );

    when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
      .thenAnswer((_) async => Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 200,
        data: [{"id": 1, "title": "Mock Title", "body": "Mock description body"}],
      ));
      
    when(() => mockDio.get('/posts/1'))
      .thenAnswer((_) async => Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 200,
        data: {"id": 1, "title": "Mock Title", "body": "Mock description body"},
      ));

    // Initialize and mock dependencies
    await di.init();
    di.sl.allowReassignment = true;
    di.sl.registerLazySingleton<Dio>(() => mockDio);
    di.sl.registerLazySingleton<ILocalPropertyDataSource>(() => mockLocalDb);
    await AppTheme.init();

    await tester.pumpWidget(const app.MyApp());
    await tester.pumpAndSettle();

    final propertyCard = find.byType(InkWell).first;
    expect(propertyCard, findsOneWidget);

    await tester.tap(propertyCard);
    await tester.pumpAndSettle();

    expect(find.text('Property Details'), findsOneWidget);
  });
}
