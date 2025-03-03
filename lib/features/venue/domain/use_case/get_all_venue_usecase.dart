

import 'package:sajilobihe_event_venue_booking_system/features/venue/domain/entity/venue.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/domain/repository/venue_repository_final.dart';

class GetAllVenuesUseCase {
  final VenueRepository repository;

  GetAllVenuesUseCase(this.repository);

  Future<List<Venue>> call() async {
    return await repository.getAllVenues();
  }
}
