import 'package:equatable/equatable.dart';

/// Encapsulates user-selected filter criteria for the property listing.
///
/// Used to persist and apply filters across app sessions. All fields are
/// optional; a `null` value means that criterion is not applied.
class FilterParams extends Equatable {
  /// Minimum acceptable property price (inclusive).
  final double? minPrice;

  /// Maximum acceptable property price (inclusive).
  final double? maxPrice;

  /// Minimum number of bedrooms required.
  final int? bedrooms;

  /// Property type to match (e.g. `"Luxury Villa"`, `"Modern Apartment"`).
  final String? propertyType;

  /// Creates a [FilterParams] with the given optional constraints.
  const FilterParams({
    this.minPrice,
    this.maxPrice,
    this.bedrooms,
    this.propertyType,
  });

  /// Serialises this instance to a JSON-compatible map for persistence.
  Map<String, dynamic> toJson() => {
    'minPrice': minPrice,
    'maxPrice': maxPrice,
    'bedrooms': bedrooms,
    'propertyType': propertyType,
  };

  /// Deserialises a [FilterParams] from a JSON map produced by [toJson].
  factory FilterParams.fromJson(Map<String, dynamic> json) => FilterParams(
    minPrice: json['minPrice'] as double?,
    maxPrice: json['maxPrice'] as double?,
    bedrooms: json['bedrooms'] as int?,
    propertyType: json['propertyType'] as String?,
  );

  @override
  List<Object?> get props => [minPrice, maxPrice, bedrooms, propertyType];

  /// Returns a copy of this instance with the given fields replaced.
  FilterParams copyWith({
    double? minPrice,
    double? maxPrice,
    int? bedrooms,
    String? propertyType,
  }) {
    return FilterParams(
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      bedrooms: bedrooms ?? this.bedrooms,
      propertyType: propertyType ?? this.propertyType,
    );
  }
}
