

import 'package:sajilobihe_event_venue_booking_system/features/booking/data/data_source/remote_datasource/booking_remote_datasource.dart';
import 'package:sajilobihe_event_venue_booking_system/features/booking/domain/entity/booking_entity.dart';
import 'package:sajilobihe_event_venue_booking_system/features/booking/domain/repository/booking_repository.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;
  BookingRepositoryImpl(this.remoteDataSource);

  @override
  Future<BookingEntity> createBooking(String venueId) async {
    // Send the correct key 'venueId' as expected by the backend.
    final bookingData = {
      'venueId': venueId,
    };
    final model = await remoteDataSource.createBooking(bookingData);
    return model;
  }

  @override
  Future<List<BookingEntity>> getUserBookings() async {
    final models = await remoteDataSource.getUserBookings();
    return models;
  }

  @override
  Future<List<BookingEntity>> getAllBookings() async {
    final models = await remoteDataSource.getAllBookings();
    return models;
  }

  @override
  Future<bool> cancelBooking(String bookingId) async {
    return await remoteDataSource.cancelBooking(bookingId);
  }

  @override
  Future<BookingEntity> approveBooking(String bookingId) async {
    final model = await remoteDataSource.approveBooking(bookingId);
    return model;
  }

  @override
  Future<bool> deleteBooking(String bookingId) async {
    return await remoteDataSource.deleteBooking(bookingId);
  }
}
