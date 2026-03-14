import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:real_estate_mvvm_app/presentation/screens/property_list_screen.dart';
import 'package:real_estate_mvvm_app/presentation/viewmodels/property_list_viewmodel.dart';
import 'package:real_estate_mvvm_app/presentation/viewmodels/property_list_state.dart';
import 'package:real_estate_mvvm_app/presentation/viewmodels/property_list_event.dart';
import 'package:real_estate_mvvm_app/core/theme/app_theme.dart';
import 'package:real_estate_mvvm_app/data/models/property_model.dart';
import 'package:real_estate_mvvm_app/domain/entities/filter_params.dart';
import 'package:bloc_test/bloc_test.dart';

class MockPropertyListViewModel extends MockBloc<PropertyEvent, PropertyState> implements PropertyListViewModel {}
class MockThemeService extends Mock implements ThemeService {}

void main() {
  late MockPropertyListViewModel mockViewModel;
  late MockThemeService mockThemeService;

  setUpAll(() {
    registerFallbackValue(const FetchPropertiesEvent());
    registerFallbackValue(const ApplyFilterEvent(FilterParams()));
  });

  setUp(() {
    mockViewModel = MockPropertyListViewModel();
    mockThemeService = MockThemeService();
    
    when(() => mockThemeService.selectedTheme).thenReturn('light');
    when(() => mockThemeService.isDarkMode).thenReturn(false);
  });

  testWidgets('PropertyListScreen shows loading indicator', (WidgetTester tester) async {
    when(() => mockViewModel.state).thenReturn(PropertyLoadingState());

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeService>.value(value: mockThemeService),
        ],
        child: BlocProvider<PropertyListViewModel>.value(
          value: mockViewModel,
          child: const MaterialApp(home: PropertyListScreen()),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('PropertyListScreen shows properties when loaded', (WidgetTester tester) async {
    final properties = [
      PropertyModel(
        propertyId: 1,
        title: 'Modern House',
        description: 'Desc',
        price: 100000,
        bedrooms: 3,
        imageUrl: 'http://image.com',
        propertyType: 'House',
      ),
    ];
    when(() => mockViewModel.state).thenReturn(PropertyLoadedState(properties));

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeService>.value(value: mockThemeService),
        ],
        child: BlocProvider<PropertyListViewModel>.value(
          value: mockViewModel,
          child: const MaterialApp(home: PropertyListScreen()),
        ),
      ),
    );

    expect(find.text('Modern House'), findsOneWidget);
  });

  testWidgets('PropertyListScreen opens filter sheet and applies filter', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 1800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    when(() => mockViewModel.state).thenReturn(const PropertyLoadedState([]));

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeService>.value(value: mockThemeService),
        ],
        child: BlocProvider<PropertyListViewModel>.value(
          value: mockViewModel,
          child: const MaterialApp(home: PropertyListScreen()),
        ),
      ),
    );

    // Tap filter icon
    await tester.tap(find.byIcon(Icons.filter_list));
    await tester.pumpAndSettle();

    expect(find.text('Filters'), findsOneWidget);

    // Tap price filter
    final budgetFilter = find.text('Budget: Under \$500,000');
    await tester.ensureVisible(budgetFilter);
    await tester.tap(budgetFilter);
    await tester.pumpAndSettle();

    verify(() => mockViewModel.add(any(that: isA<ApplyFilterEvent>()))).called(1);
    expect(find.text('Filters'), findsNothing);
  });
}
