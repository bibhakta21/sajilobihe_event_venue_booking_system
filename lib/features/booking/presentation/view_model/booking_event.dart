import 'package:equatable/equatable.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();
  @override
  List<Object?> get props => [];
}

class CreateBookingEvent extends BookingEvent {
  final String venueId;
  const CreateBookingEvent(this.venueId);
  @override
  List<Object?> get props => [venueId];
}

class LoadUserBookingsEvent extends BookingEvent {}

class LoadAllBookingsEvent extends BookingEvent {}

class CancelBookingEvent extends BookingEvent {
  final String bookingId;
  const CancelBookingEvent(this.bookingId);
  @override
  List<Object?> get props => [bookingId];
}

class ApproveBookingEvent extends BookingEvent {
  final String bookingId;
  const ApproveBookingEvent(this.bookingId);
  @override
  List<Object?> get props => [bookingId];
}

class DeleteBookingEvent extends BookingEvent {
  final String bookingId;
  const DeleteBookingEvent(this.bookingId);
  @override
  List<Object?> get props => [bookingId];
}
