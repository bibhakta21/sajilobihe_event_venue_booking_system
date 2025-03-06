import 'package:sajilobihe_event_venue_booking_system/features/booking/domain/entity/booking_entity.dart';

abstract class IBookingDataSource {
  Future<void> createBooking(BookingEntity bookingEntity);
  Future<List<BookingEntity>> getUserBookings(String userId);
  Future<List<BookingEntity>> getAllBookings();
  Future<void> cancelBooking(String bookingId);
  Future<void> deleteBooking(String bookingId);
}
