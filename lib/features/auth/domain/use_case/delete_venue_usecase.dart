

import 'package:sajilobihe_event_venue_booking_system/features/auth/domain/repository/venue_repository_final.dart';

class DeleteVenueUseCase {
  final VenueRepository repository;

  DeleteVenueUseCase(this.repository);

  Future<void> call(String id) async {
    await repository.deleteVenue(id);
  }
}
