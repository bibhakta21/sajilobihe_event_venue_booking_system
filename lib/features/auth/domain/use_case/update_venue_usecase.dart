

import 'package:sajilobihe_event_venue_booking_system/features/auth/domain/entity/venue.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/domain/repository/venue_repository_final.dart';

class UpdateVenueUseCase {
  final VenueRepository repository;

  UpdateVenueUseCase(this.repository);

  Future<Venue> call(
    String id, {
      String? name,
      String? location,
      int? capacity,
      double? price,
      String? description,
      List<String>? images,
      bool? available,
    }
  ) async {
    return await repository.updateVenue(
      id,
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
