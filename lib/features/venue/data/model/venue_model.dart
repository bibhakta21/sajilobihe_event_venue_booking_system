import 'package:sajilobihe_event_venue_booking_system/features/venue/domain/entity/venue.dart';



class VenueModel extends Venue {
  VenueModel({
    required String id,
    required String name,
    required String location,
    required int capacity,
    required double price,
    required String description,
    required List<String> images,
    required bool available,
  }) : super(
          id: id,
          name: name,
          location: location,
          capacity: capacity,
          price: price,
          description: description,
          images: images,
          available: available,
        );

  factory VenueModel.fromJson(Map<String, dynamic> json) {
    return VenueModel(
      id: json['_id'] ?? '',
      name: json['name'],
      location: json['location'],
      capacity: json['capacity'],
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      images: List<String>.from(json['images'] ?? []),
      available: json['available'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'location': location,
      'capacity': capacity,
      'price': price,
      'description': description,
      'images': images,
      'available': available,
    };
  }
}
