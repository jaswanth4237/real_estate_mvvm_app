import '../entities/filter_params.dart';

abstract class IFilterPersistenceService {
  Future<void> saveFilters(FilterParams filters);
  FilterParams? getFilters();
}
