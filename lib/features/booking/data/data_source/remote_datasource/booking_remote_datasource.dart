import 'package:dio/dio.dart';
import 'package:sajilobihe_event_venue_booking_system/app/constants/api_endpoints.dart';
import 'package:sajilobihe_event_venue_booking_system/features/booking/data/model/booking_api_model.dart';

abstract class BookingRemoteDataSource {
  Future<BookingModel> createBooking(Map<String, dynamic> bookingData);
  Future<List<BookingModel>> getUserBookings();
  Future<List<BookingModel>> getAllBookings();
  Future<bool> cancelBooking(String bookingId);
  Future<BookingModel> approveBooking(String bookingId);
  Future<bool> deleteBooking(String bookingId);
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final Dio dio;
  BookingRemoteDataSourceImpl(this.dio);

  @override
  Future<BookingModel> createBooking(Map<String, dynamic> bookingData) async {
    try {
      final response = await dio.post(ApiEndpoints.bookings, data: bookingData);
      if (response.statusCode == 201) {
        return BookingModel.fromJson(response.data['booking']);
      } else {
        // If the status is 400 or other, the DioErrorInterceptor will already set the error text.
        // So we can just throw an Exception or return a default error:
        throw Exception('Failed to create booking');
      }
    } on DioException catch (dioErr) {
      // Re-throw to let the BLoC handle it
      rethrow;
    }
  }

  @override
  Future<List<BookingModel>> getUserBookings() async {
    final response = await dio.get(ApiEndpoints.userBookings);
    if (response.statusCode == 200) {
      List data = response.data;
      return data.map((e) => BookingModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load user bookings");
    }
  }

  @override
  Future<List<BookingModel>> getAllBookings() async {
    final response = await dio.get(ApiEndpoints.bookings);
    if (response.statusCode == 200) {
      List data = response.data;
      return data.map((e) => BookingModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load all bookings");
    }
  }

  @override
  Future<bool> cancelBooking(String bookingId) async {
    final response =
        await dio.put("${ApiEndpoints.bookings}/$bookingId/cancel");
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<BookingModel> approveBooking(String bookingId) async {
    final response =
        await dio.put("${ApiEndpoints.bookings}/$bookingId/approve");
    if (response.statusCode == 200) {
      return BookingModel.fromJson(response.data['booking']);
    } else {
      throw Exception("Failed to approve booking");
    }
  }

  @override
  Future<bool> deleteBooking(String bookingId) async {
    final response = await dio.delete("${ApiEndpoints.bookings}/$bookingId");
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
