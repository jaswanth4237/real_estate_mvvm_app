import 'package:json_annotation/json_annotation.dart';

part 'property_model.g.dart';

@JsonSerializable()
class PropertyModel {
  final int propertyId;
  final String title;
  final String description;
  final double price;
  final int bedrooms;
  final String imageUrl;
  final String propertyType;
  final bool isFavorite;

  PropertyModel({
    required this.propertyId,
    required this.title,
    required this.description,
    required this.price,
    required this.bedrooms,
    required this.imageUrl,
    required this.propertyType,
    this.isFavorite = false,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) => _$PropertyModelFromJson(json);

  Map<String, dynamic> toJson() => _$PropertyModelToJson(this);

  PropertyModel copyWith({
    int? propertyId,
    String? title,
    String? description,
    double? price,
    int? bedrooms,
    String? imageUrl,
    String? propertyType,
    bool? isFavorite,
  }) {
    return PropertyModel(
      propertyId: propertyId ?? this.propertyId,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      bedrooms: bedrooms ?? this.bedrooms,
      imageUrl: imageUrl ?? this.imageUrl,
      propertyType: propertyType ?? this.propertyType,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
