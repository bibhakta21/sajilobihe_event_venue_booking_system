import 'package:json_annotation/json_annotation.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/domain/entity/venue_entity.dart';


part 'venue_api_model.g.dart';

@JsonSerializable()
class VenueApiModel {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String location;
  final int capacity;
  final double price;
  final String description;
  final List<String> images;
  final bool available;

  VenueApiModel({
    required this.id,
    required this.name,
    required this.location,
    required this.capacity,
    required this.price,
    required this.description,
    required this.images,
    required this.available,
  });

  factory VenueApiModel.fromJson(Map<String, dynamic> json) => _$VenueApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$VenueApiModelToJson(this);

  VenueEntity toEntity() {
    return VenueEntity(
      id: id,
      name: name,
      location: location,
      capacity: capacity,
      price: price,
      description: description,
      images: images,
      available: available,
    );
  }
}
