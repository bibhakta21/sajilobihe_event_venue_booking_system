import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sajilobihe_event_venue_booking_system/features/booking/domain/use_case/approve_bookings_usecase.dart';
import 'package:sajilobihe_event_venue_booking_system/features/booking/domain/use_case/cancel_bookings_usecase.dart';
import 'package:sajilobihe_event_venue_booking_system/features/booking/domain/use_case/create_booking_usecase.dart';
import 'package:sajilobihe_event_venue_booking_system/features/booking/domain/use_case/delete_bookings_usecase.dart';
import 'package:sajilobihe_event_venue_booking_system/features/booking/domain/use_case/get_all_bookings_usecase.dart';
import 'package:sajilobihe_event_venue_booking_system/features/booking/domain/use_case/get_user_bookings.dart';

import 'booking_event.dart';
import 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final CreateBookingUseCase createBookingUseCase;
  final GetUserBookingsUseCase getUserBookingsUseCase;
  final GetAllBookingsUseCase getAllBookingsUseCase;
  final CancelBookingUseCase cancelBookingUseCase;
  final ApproveBookingUseCase approveBookingUseCase;
  final DeleteBookingUseCase deleteBookingUseCase;

  BookingBloc({
    required this.createBookingUseCase,
    required this.getUserBookingsUseCase,
    required this.getAllBookingsUseCase,
    required this.cancelBookingUseCase,
    required this.approveBookingUseCase,
    required this.deleteBookingUseCase,
  }) : super(BookingInitial()) {
    on<CreateBookingEvent>(_onCreateBooking);
    on<LoadUserBookingsEvent>(_onLoadUserBookings);
    on<LoadAllBookingsEvent>(_onLoadAllBookings);
    on<CancelBookingEvent>(_onCancelBooking);
    on<ApproveBookingEvent>(_onApproveBooking);
    on<DeleteBookingEvent>(_onDeleteBooking);
  }

  Future<void> _onCreateBooking(
      CreateBookingEvent event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    try {
      final booking = await createBookingUseCase(event.venueId);
      emit(BookingCreated(booking));
    } catch (e) {
      emit(BookingOperationFailure(e.toString()));
    }
  }

  Future<void> _onLoadUserBookings(
      LoadUserBookingsEvent event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    try {
      final bookings = await getUserBookingsUseCase();
      emit(UserBookingsLoaded(bookings));
    } catch (e) {
      emit(BookingOperationFailure(e.toString()));
    }
  }

  Future<void> _onLoadAllBookings(
      LoadAllBookingsEvent event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    try {
      final bookings = await getAllBookingsUseCase();
      emit(AllBookingsLoaded(bookings));
    } catch (e) {
      emit(BookingOperationFailure(e.toString()));
    }
  }

  Future<void> _onCancelBooking(
      CancelBookingEvent event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    try {
      final success = await cancelBookingUseCase(event.bookingId);
      if (success) {
        emit(BookingOperationSuccess("Booking canceled successfully."));
        add(LoadUserBookingsEvent());
      } else {
        emit(BookingOperationFailure("Failed to cancel booking."));
      }
    } catch (e) {
      emit(BookingOperationFailure(e.toString()));
    }
  }

  Future<void> _onApproveBooking(
      ApproveBookingEvent event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    try {
      final booking = await approveBookingUseCase(event.bookingId);
      emit(BookingOperationSuccess("Booking approved successfully."));
      add(LoadAllBookingsEvent());
    } catch (e) {
      emit(BookingOperationFailure(e.toString()));
    }
  }

  Future<void> _onDeleteBooking(
      DeleteBookingEvent event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    try {
      final success = await deleteBookingUseCase(event.bookingId);
      if (success) {
        emit(BookingOperationSuccess("Booking deleted successfully."));
        add(LoadAllBookingsEvent());
      } else {
        emit(BookingOperationFailure("Failed to delete booking."));
      }
    } catch (e) {
      emit(BookingOperationFailure(e.toString()));
    }
  }
}
