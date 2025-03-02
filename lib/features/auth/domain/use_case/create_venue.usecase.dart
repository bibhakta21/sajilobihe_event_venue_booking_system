
import 'package:sajilobihe_event_venue_booking_system/features/auth/domain/entity/venue.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/domain/repository/venue_repository_final.dart';

class AddVenueUseCase {
  final VenueRepository repository;

  AddVenueUseCase(this.repository);

  Future<Venue> call({
    required String name,
    required String location,
    required int capacity,
    required double price,
    required String description,
    required List<String> images,
  }) async {
    return await repository.addVenue(
      name: name,
      location: location,
      capacity: capacity,
      price: price,
      description: description,
      images: images,
    );
  }
}
