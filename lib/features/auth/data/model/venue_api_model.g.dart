// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VenueApiModel _$VenueApiModelFromJson(Map<String, dynamic> json) =>
    VenueApiModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      location: json['location'] as String,
      capacity: (json['capacity'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      available: json['available'] as bool,
    );

Map<String, dynamic> _$VenueApiModelToJson(VenueApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'location': instance.location,
      'capacity': instance.capacity,
      'price': instance.price,
      'description': instance.description,
      'images': instance.images,
      'available': instance.available,
    };
