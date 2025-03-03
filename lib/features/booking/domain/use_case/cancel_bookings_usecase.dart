import '../repository/booking_repository.dart';

class CancelBookingUseCase {
  final BookingRepository repository;
  CancelBookingUseCase(this.repository);

  Future<bool> call(String bookingId) async {
    return await repository.cancelBooking(bookingId);
  }
}
