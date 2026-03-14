import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/property_model.dart';
import '../../core/utils/filter_persistence_service.dart';
import '../../domain/usecases/get_properties_usecase.dart';
import '../../domain/entities/filter_params.dart';
import 'property_list_event.dart';
import 'property_list_state.dart';

class PropertyListViewModel extends Bloc<PropertyEvent, PropertyState> {
  final GetPropertiesUseCase getPropertiesUseCase;
  final FilterPersistenceService filterPersistenceService;
  List<PropertyModel> _allProperties = [];
  bool _isFetching = false;

  PropertyListViewModel({
    required this.getPropertiesUseCase,
    required this.filterPersistenceService,
  }) : super(PropertyInitialState()) {
    on<FetchPropertiesEvent>((event, emit) async {
      if (_isFetching) {
        return;
      }
      _isFetching = true;
      try {
        emit(PropertyLoadingState());

        final result = await getPropertiesUseCase.execute(page: event.page);
        result.fold(
          (data) {
            _allProperties = data;
            final savedFilters = filterPersistenceService.getFilters();
            final filteredData = savedFilters != null
                ? _applyFilters(data, savedFilters)
                : data;
            emit(PropertyLoadedState(filteredData));
          },
          (failure) => emit(PropertyErrorState(failure.message)),
        );
      } finally {
        _isFetching = false;
      }
    });

    on<ApplyFilterEvent>((event, emit) async {
      await filterPersistenceService.saveFilters(event.filters);
      // Always filter from the full set of properties
      final filteredData = _applyFilters(_allProperties, event.filters);
      emit(PropertyLoadedState(filteredData));
    });
  }

  List<PropertyModel> _applyFilters(List<PropertyModel> list, FilterParams filters) {
    return list.where((p) {
      bool matches = true;
      if (filters.minPrice != null) matches &= p.price >= filters.minPrice!;
      if (filters.maxPrice != null) matches &= p.price <= filters.maxPrice!;
      if (filters.bedrooms != null) matches &= p.bedrooms >= (filters.bedrooms ?? 0);
      if (filters.propertyType != null && filters.propertyType!.isNotEmpty) {
        matches &= p.propertyType.toLowerCase() == filters.propertyType!.toLowerCase();
      }
      return matches;
    }).toList();
  }
}
