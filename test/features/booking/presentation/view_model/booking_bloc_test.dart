// 4  bloc test for booking
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sajilobihe_event_venue_booking_system/features/booking/domain/entity/booking_entity.dart';
import 'package:sajilobihe_event_venue_booking_system/features/booking/domain/use_case/approve_bookings_usecase.dart';
import 'package:sajilobihe_event_venue_booking_system/features/booking/domain/use_case/cancel_bookings_usecase.dart';
import 'package:sajilobihe_event_venue_booking_system/features/booking/domain/use_case/create_booking_usecase.dart';
import 'package:sajilobihe_event_venue_booking_system/features/booking/domain/use_case/delete_bookings_usecase.dart';
import 'package:sajilobihe_event_venue_booking_system/features/booking/domain/use_case/get_all_bookings_usecase.dart';
import 'package:sajilobihe_event_venue_booking_system/features/booking/domain/use_case/get_user_bookings.dart';
import 'package:sajilobihe_event_venue_booking_system/features/booking/presentation/view_model/booking_bloc.dart';
import 'package:sajilobihe_event_venue_booking_system/features/booking/presentation/view_model/booking_event.dart';
import 'package:sajilobihe_event_venue_booking_system/features/booking/presentation/view_model/booking_state.dart';

/// Create mocks for each use case dependency.
class MockCreateBookingUseCase extends Mock implements CreateBookingUseCase {}

class MockGetUserBookingsUseCase extends Mock
    implements GetUserBookingsUseCase {}

class MockGetAllBookingsUseCase extends Mock implements GetAllBookingsUseCase {}

class MockCancelBookingUseCase extends Mock implements CancelBookingUseCase {}

class MockApproveBookingUseCase extends Mock implements ApproveBookingUseCase {}

class MockDeleteBookingUseCase extends Mock implements DeleteBookingUseCase {}

void main() {
  late MockCreateBookingUseCase mockCreateBookingUseCase;
  late MockGetUserBookingsUseCase mockGetUserBookingsUseCase;
  late MockGetAllBookingsUseCase mockGetAllBookingsUseCase;
  late MockCancelBookingUseCase mockCancelBookingUseCase;
  late MockApproveBookingUseCase mockApproveBookingUseCase;
  late MockDeleteBookingUseCase mockDeleteBookingUseCase;
  late BookingBloc bookingBloc;

  setUp(() {
    mockCreateBookingUseCase = MockCreateBookingUseCase();
    mockGetUserBookingsUseCase = MockGetUserBookingsUseCase();
    mockGetAllBookingsUseCase = MockGetAllBookingsUseCase();
    mockCancelBookingUseCase = MockCancelBookingUseCase();
    mockApproveBookingUseCase = MockApproveBookingUseCase();
    mockDeleteBookingUseCase = MockDeleteBookingUseCase();

    bookingBloc = BookingBloc(
      createBookingUseCase: mockCreateBookingUseCase,
      getUserBookingsUseCase: mockGetUserBookingsUseCase,
      getAllBookingsUseCase: mockGetAllBookingsUseCase,
      cancelBookingUseCase: mockCancelBookingUseCase,
      approveBookingUseCase: mockApproveBookingUseCase,
      deleteBookingUseCase: mockDeleteBookingUseCase,
    );
  });

  tearDown(() {
    bookingBloc.close();
  });

  // A dummy booking for testing
  final dummyBooking = BookingEntity(
    id: '1',
    userId: 'user1',
    venueId: 'venue1',
    bookingDate: DateTime.now(),
    status: 'pending',
    userName: 'Test User',
    userEmail: 'test@example.com',
    userPhone: '1234567890',
    venueName: 'Test Venue',
    venueImages: ['image1.jpg'],
    venuePrice: 100.0,
    venueCapacity: 200,
  );

  group('BookingBloc Tests', () {
    blocTest<BookingBloc, BookingState>(
      'emits [BookingLoading, BookingCreated] when CreateBookingEvent is added and use case succeeds',
      build: () {
        when(() => mockCreateBookingUseCase('venue1'))
            .thenAnswer((_) async => dummyBooking);
        return bookingBloc;
      },
      act: (bloc) => bloc.add(const CreateBookingEvent('venue1')),
      expect: () => [
        isA<BookingLoading>(),
        isA<BookingCreated>()
            .having((state) => state.booking, 'booking', dummyBooking),
      ],
      verify: (_) {
        verify(() => mockCreateBookingUseCase('venue1')).called(1);
      },
    );

    blocTest<BookingBloc, BookingState>(
      'emits [BookingLoading, UserBookingsLoaded] when LoadUserBookingsEvent is added',
      build: () {
        when(() => mockGetUserBookingsUseCase())
            .thenAnswer((_) async => [dummyBooking]);
        return bookingBloc;
      },
      act: (bloc) => bloc.add(LoadUserBookingsEvent()),
      expect: () => [
        isA<BookingLoading>(),
        isA<UserBookingsLoaded>()
            .having((state) => state.bookings, 'bookings', [dummyBooking]),
      ],
      verify: (_) {
        verify(() => mockGetUserBookingsUseCase()).called(1);
      },
    );

    blocTest<BookingBloc, BookingState>(
      'emits [BookingLoading, BookingOperationFailure] when CreateBookingEvent fails',
      build: () {
        when(() => mockCreateBookingUseCase('venue1'))
            .thenThrow(Exception('Failed to create booking'));

        return bookingBloc;
      },
      act: (bloc) => bloc.add(const CreateBookingEvent('venue1')),
      expect: () => [
        isA<BookingLoading>(),
        isA<BookingOperationFailure>().having(
          (state) => state.error,
          'error message',
          'Exception: Failed to create booking',
        ),
      ],
      verify: (_) {
        verify(() => mockCreateBookingUseCase('venue1')).called(1);
      },
    );

    blocTest<BookingBloc, BookingState>(
      'emits [BookingLoading, AllBookingsLoaded] when LoadAllBookingsEvent is added',
      build: () {
        when(() => mockGetAllBookingsUseCase())
            .thenAnswer((_) async => [dummyBooking]);
        return bookingBloc;
      },
      act: (bloc) => bloc.add(LoadAllBookingsEvent()),
      expect: () => [
        isA<BookingLoading>(),
        isA<AllBookingsLoaded>().having(
          (state) => state.bookings,
          'bookings',
          [dummyBooking],
        ),
      ],
      verify: (_) {
        verify(() => mockGetAllBookingsUseCase()).called(1);
      },
    );

    blocTest<BookingBloc, BookingState>(
      'emits [BookingLoading, BookingOperationFailure] when CancelBookingEvent fails',
      build: () {
        when(() => mockCancelBookingUseCase('1'))
            .thenThrow(Exception('Cancellation failed'));
        return bookingBloc;
      },
      act: (bloc) => bloc.add(const CancelBookingEvent('1')),
      expect: () => [
        isA<BookingLoading>(),
        isA<BookingOperationFailure>().having(
          (state) => state.error,
          'error message',
          'Exception: Cancellation failed',
        ),
      ],
      verify: (_) {
        verify(() => mockCancelBookingUseCase('1')).called(1);
      },
    );
  });
}
