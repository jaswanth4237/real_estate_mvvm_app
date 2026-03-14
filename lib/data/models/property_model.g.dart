// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_model.dart';


// JsonSerializableGenerator

PropertyModel _$PropertyModelFromJson(Map<String, dynamic> json) =>
    PropertyModel(
      propertyId: (json['propertyId'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      bedrooms: (json['bedrooms'] as num).toInt(),
      imageUrl: json['imageUrl'] as String,
      propertyType: json['propertyType'] as String,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );

Map<String, dynamic> _$PropertyModelToJson(PropertyModel instance) =>
    <String, dynamic>{
      'propertyId': instance.propertyId,
      'title': instance.title,
      'description': instance.description,
      'price': instance.price,
      'bedrooms': instance.bedrooms,
      'imageUrl': instance.imageUrl,
      'propertyType': instance.propertyType,
      'isFavorite': instance.isFavorite,
    };
