import '../../data/models/property_model.dart';

/// Contract for the remote property REST API client.
///
/// Implementations use Dio with custom interceptors for logging and error
/// handling, and cache raw responses as JSON files on disk.
abstract class IPropertyApiClient {
  /// Fetches a paginated list of [PropertyModel] from the remote API.
  ///
  /// [page] is the 1-based page number; [limit] is the page size.
  Future<List<PropertyModel>> fetchProperties({int page = 1, int limit = 10});

  /// Fetches the full details of the property identified by [id].
  Future<PropertyModel> getPropertyDetails(int id);
}
