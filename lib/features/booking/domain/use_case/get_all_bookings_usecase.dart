
import 'package:sajilobihe_event_venue_booking_system/features/booking/domain/entity/booking_entity.dart';

import '../repository/booking_repository.dart';

class GetAllBookingsUseCase {
  final BookingRepository repository;
  GetAllBookingsUseCase(this.repository);

  Future<List<BookingEntity>> call() async {
    return await repository.getAllBookings();
  }
}
