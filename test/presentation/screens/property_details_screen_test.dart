import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:real_estate_mvvm_app/presentation/screens/property_details_screen.dart';
import 'package:real_estate_mvvm_app/presentation/viewmodels/property_details_viewmodel.dart';
import 'package:real_estate_mvvm_app/core/theme/app_theme.dart';
import 'package:real_estate_mvvm_app/core/di/accessibility/accessibility_service.dart';
import 'package:real_estate_mvvm_app/data/models/property_model.dart';

class MockPropertyDetailsViewModel extends Mock implements PropertyDetailsViewModel {}
class MockThemeService extends Mock implements ThemeService {}
class MockAccessibilityService extends Mock implements AccessibilityService {}

void main() {
  late MockPropertyDetailsViewModel mockViewModel;
  late MockThemeService mockThemeService;
  late MockAccessibilityService mockAccessibilityService;

  setUp(() {
    mockViewModel = MockPropertyDetailsViewModel();
    mockThemeService = MockThemeService();
    mockAccessibilityService = MockAccessibilityService();
    
    when(() => mockThemeService.selectedTheme).thenReturn('light');
    when(() => mockThemeService.isDarkMode).thenReturn(false);
  });

  final tProperty = PropertyModel(
    propertyId: 1,
    title: 'Modern House',
    description: 'Beautiful modern home',
    price: 350000,
    bedrooms: 4,
    imageUrl: 'http://image.com',
    propertyType: 'House',
  );

  testWidgets('PropertyDetailsScreen displays property info', (WidgetTester tester) async {
    when(() => mockViewModel.property).thenReturn(tProperty);
    when(() => mockViewModel.isLoading).thenReturn(false);
    when(() => mockViewModel.errorMessage).thenReturn(null);
    when(() => mockViewModel.loadPropertyDetails(1)).thenAnswer((_) async => Future.value());

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeService>.value(value: mockThemeService),
          ChangeNotifierProvider<PropertyDetailsViewModel>.value(value: mockViewModel),
          Provider<AccessibilityService>.value(value: mockAccessibilityService),
        ],
        child: const MaterialApp(
          home: PropertyDetailsScreen(propertyId: 1),
        ),
      ),
    );

    expect(find.text('Modern House'), findsOneWidget);
    expect(find.text('\$350000'), findsOneWidget);
    expect(find.text('Beautiful modern home'), findsOneWidget);
  });
}
