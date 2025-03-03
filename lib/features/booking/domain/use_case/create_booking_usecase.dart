
import 'package:sajilobihe_event_venue_booking_system/features/booking/domain/entity/booking_entity.dart';

import '../repository/booking_repository.dart';

class CreateBookingUseCase {
  final BookingRepository repository;
  CreateBookingUseCase(this.repository);

  Future<BookingEntity> call(String venueId) async {
    return await repository.createBooking(venueId);
  }
}
