import 'package:equatable/equatable.dart';

abstract class VenueEvent extends Equatable {
  const VenueEvent();

  @override
  List<Object?> get props => [];
}

class LoadVenues extends VenueEvent {}

class AddVenueEvent extends VenueEvent {
  final String name;
  final String location;
  final int capacity;
  final double price;
  final String description;
  final List<String> images;

  const AddVenueEvent({
    required this.name,
    required this.location,
    required this.capacity,
    required this.price,
    required this.description,
    required this.images,
  });

  @override
  List<Object?> get props => [name, location, capacity, price, description, images];
}

class UpdateVenueEvent extends VenueEvent {
  final String id;
  final String? name;
  final String? location;
  final int? capacity;
  final double? price;
  final String? description;
  final List<String>? images;
  final bool? available;

  const UpdateVenueEvent({
    required this.id,
    this.name,
    this.location,
    this.capacity,
    this.price,
    this.description,
    this.images,
    this.available,
  });

  @override
  List<Object?> get props => [id, name, location, capacity, price, description, images, available];
}

class DeleteVenueEvent extends VenueEvent {
  final String id;

  const DeleteVenueEvent(this.id);

  @override
  List<Object?> get props => [id];
}
