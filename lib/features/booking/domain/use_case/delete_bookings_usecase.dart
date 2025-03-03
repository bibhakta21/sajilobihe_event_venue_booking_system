import '../repository/booking_repository.dart';

class DeleteBookingUseCase {
  final BookingRepository repository;
  DeleteBookingUseCase(this.repository);

  Future<bool> call(String bookingId) async {
    return await repository.deleteBooking(bookingId);
  }
}
