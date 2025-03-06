import 'package:sajilobihe_event_venue_booking_system/core/network/hive_service.dart';
import 'package:sajilobihe_event_venue_booking_system/features/booking/data/data_source/booking_data_source.dart';
import 'package:sajilobihe_event_venue_booking_system/features/booking/data/model/booking_hive_model.dart';
import 'package:sajilobihe_event_venue_booking_system/features/booking/domain/entity/booking_entity.dart';

class BookingLocalDataSource implements IBookingDataSource {
  final HiveService _hiveService;

  BookingLocalDataSource(this._hiveService);

  @override
  Future<void> createBooking(BookingEntity bookingEntity) async {
    try {
      final bookingModel = BookingHiveModel.fromEntity(bookingEntity);
      await _hiveService.addBooking(bookingModel);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<BookingEntity>> getUserBookings(String userId) async {
    try {
      final bookings = await _hiveService.getUserBookings(userId);
      return bookings.map((e) => e.toEntity()).toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<BookingEntity>> getAllBookings() async {
    try {
      final bookings = await _hiveService.getAllBookings();
      return bookings.map((e) => e.toEntity()).toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    try {
      await _hiveService.cancelBooking(bookingId);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> deleteBooking(String bookingId) async {
    try {
      await _hiveService.deleteBooking(bookingId);
    } catch (e) {
      throw Exception(e);
    }
  }
}
