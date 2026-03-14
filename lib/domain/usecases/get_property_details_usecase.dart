import '../../core/utils/result.dart';
import '../../data/models/property_model.dart';
import '../../data/repositories/property_repository.dart';

/// Use case for fetching details of a specific property.
class GetPropertyDetailsUseCase {
  final PropertyRepository repository;

  GetPropertyDetailsUseCase(this.repository);

  /// Executes the use case to fetch the details of the property with the given [id].
  Future<Result<PropertyModel>> execute(int id) async {
    return await repository.getPropertyDetails(id);
  }
}
