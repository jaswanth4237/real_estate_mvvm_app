import 'package:equatable/equatable.dart';

class FilterParams extends Equatable {
  final double? minPrice;
  final double? maxPrice;
  final int? bedrooms;
  final String? propertyType;

  const FilterParams({
    this.minPrice,
    this.maxPrice,
    this.bedrooms,
    this.propertyType,
  });

  Map<String, dynamic> toJson() => {
    'minPrice': minPrice,
    'maxPrice': maxPrice,
    'bedrooms': bedrooms,
    'propertyType': propertyType,
  };

  factory FilterParams.fromJson(Map<String, dynamic> json) => FilterParams(
    minPrice: json['minPrice'],
    maxPrice: json['maxPrice'],
    bedrooms: json['bedrooms'],
    propertyType: json['propertyType'],
  );

  @override
  List<Object?> get props => [minPrice, maxPrice, bedrooms, propertyType];

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
