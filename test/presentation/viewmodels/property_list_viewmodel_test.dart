import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:real_estate_mvvm_app/core/utils/result.dart';
import 'package:real_estate_mvvm_app/data/models/property_model.dart';
import 'package:real_estate_mvvm_app/domain/usecases/get_properties_usecase.dart';
import 'package:real_estate_mvvm_app/presentation/viewmodels/property_list_event.dart';
import 'package:real_estate_mvvm_app/presentation/viewmodels/property_list_state.dart';
import 'package:real_estate_mvvm_app/presentation/viewmodels/property_list_viewmodel.dart';
import 'package:real_estate_mvvm_app/core/utils/filter_persistence_service.dart';
import 'package:real_estate_mvvm_app/domain/entities/filter_params.dart';

class MockGetPropertiesUseCase extends Mock implements GetPropertiesUseCase {}
class MockFilterPersistenceService extends Mock implements FilterPersistenceService {}

void main() {
  late PropertyListViewModel viewModel;
  late MockGetPropertiesUseCase mockUseCase;
  late MockFilterPersistenceService mockFilterService;

  setUpAll(() {
    registerFallbackValue(FilterParams());
  });

  setUp(() {
    mockUseCase = MockGetPropertiesUseCase();
    mockFilterService = MockFilterPersistenceService();
    
    when(() => mockFilterService.getFilters()).thenReturn(null);

    viewModel = PropertyListViewModel(
      getPropertiesUseCase: mockUseCase,
      filterPersistenceService: mockFilterService,
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

  blocTest<PropertyListViewModel, PropertyState>(
    'emits [PropertyLoadingState, PropertyLoadedState] when successful',
    build: () {
      when(() => mockUseCase.execute(page: 1))
          .thenAnswer((_) async => Success(tProperties));
      return viewModel;
    },
    act: (bloc) => bloc.add(const FetchPropertiesEvent(page: 1)),
    expect: () => [
      PropertyLoadingState(),
      PropertyLoadedState(tProperties),
    ],
  );

  blocTest<PropertyListViewModel, PropertyState>(
    'emits [PropertyLoadedState] with filtered properties on ApplyFilterEvent',
    build: () {
      when(() => mockFilterService.saveFilters(any())).thenAnswer((_) async => Future.value());
      return viewModel;
    },
    seed: () => PropertyLoadedState(tProperties),
    act: (bloc) => bloc.add(ApplyFilterEvent(FilterParams(minPrice: 200000))),
    expect: () => [
      isA<PropertyLoadedState>().having((s) => s.properties.length, 'length', 0),
    ],
  );
}
