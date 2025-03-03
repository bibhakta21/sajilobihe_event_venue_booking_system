
import 'package:sajilobihe_event_venue_booking_system/features/booking/domain/entity/booking_entity.dart';

import '../repository/booking_repository.dart';

class GetUserBookingsUseCase {
  final BookingRepository repository;
  GetUserBookingsUseCase(this.repository);

  Future<List<BookingEntity>> call() async {
    return await repository.getUserBookings();
  }
}
