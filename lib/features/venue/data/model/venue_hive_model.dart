import 'package:hive_flutter/hive_flutter.dart';
import 'package:equatable/equatable.dart';
import 'package:sajilobihe_event_venue_booking_system/app/constants/hive_table_constant.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/domain/entity/venue_entity.dart';

part 'Venue_hive_model.g.dart'; // Required for build_runner to generate code.

@HiveType(typeId: HiveTableConstant.venueTableId)
class VenueHiveModel extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String location;

  @HiveField(3)
  final int capacity;

  @HiveField(4)
  final double price;

  @HiveField(5)
  final String description;

  @HiveField(6)
  final List<String> images;

  @HiveField(7)
  final bool available;

  VenueHiveModel({
    required this.id,
    required this.name,
    required this.location,
    required this.capacity,
    required this.price,
    required this.description,
    required this.images,
    required this.available,
  });

  factory VenueHiveModel.fromEntity(VenueEntity entity) {
    return VenueHiveModel(
      id: entity.id,
      name: entity.name,
      location: entity.location,
      capacity: entity.capacity,
      price: entity.price,
      description: entity.description,
      images: entity.images,
      available: entity.available,
    );
  }

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

  @override
  List<Object?> get props => [id, name, location, capacity, price, description, images, available];
}
