import '../../core/utils/result.dart';
import '../../data/models/property_model.dart';
import '../../data/repositories/property_repository.dart';

/// Use case for fetching a list of properties.
class GetPropertiesUseCase {
  final PropertyRepository repository;

  GetPropertiesUseCase(this.repository);

  /// Executes the use case to fetch the properties for the specified [page].
  Future<Result<List<PropertyModel>>> execute({int page = 1}) async {
    return await repository.fetchProperties(page: page);
  }
}
