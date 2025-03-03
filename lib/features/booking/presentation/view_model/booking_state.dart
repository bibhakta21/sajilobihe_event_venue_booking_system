import 'package:equatable/equatable.dart';
import 'package:sajilobihe_event_venue_booking_system/features/booking/domain/entity/booking_entity.dart';


abstract class BookingState extends Equatable {
  const BookingState();
  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingCreated extends BookingState {
  final BookingEntity booking;
  const BookingCreated(this.booking);
  @override
  List<Object?> get props => [booking];
}

class UserBookingsLoaded extends BookingState {
  final List<BookingEntity> bookings;
  const UserBookingsLoaded(this.bookings);
  @override
  List<Object?> get props => [bookings];
}

class AllBookingsLoaded extends BookingState {
  final List<BookingEntity> bookings;
  const AllBookingsLoaded(this.bookings);
  @override
  List<Object?> get props => [bookings];
}

class BookingOperationSuccess extends BookingState {
  final String message;
  const BookingOperationSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class BookingOperationFailure extends BookingState {
  final String error;
  const BookingOperationFailure(this.error);
  @override
  List<Object?> get props => [error];
}
