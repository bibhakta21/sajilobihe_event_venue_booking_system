import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sajilobihe_event_venue_booking_system/features/booking/domain/entity/booking_entity.dart';
import 'package:sajilobihe_event_venue_booking_system/features/booking/domain/repository/booking_repository.dart';
import 'package:sajilobihe_event_venue_booking_system/features/booking/domain/use_case/get_user_bookings.dart';


/// ✅ **Mock Booking Repository**
class MockBookingRepository extends Mock implements BookingRepository {}

void main() {
  late GetUserBookingsUseCase useCase;
  late MockBookingRepository mockBookingRepository;

  setUp(() {
    mockBookingRepository = MockBookingRepository();
    useCase = GetUserBookingsUseCase(mockBookingRepository);
  });
  /// Sample Booking Data
  final tBookings = [
    BookingEntity(
      id: '1',
      userId: '123',
      venueId: '456',
      bookingDate: DateTime(2025, 03, 10),
      status: 'confirmed',
      userName: 'bibhakta lamsal',
      userEmail: 'bibhakta@gmail.com',
      userPhone: '+977 9800000000',
      venueName: 'Grand Hall',
      venueImages: ['image1.jpg'],
      venuePrice: 10000.0,
      venueCapacity: 500,
    ),
     BookingEntity(
      id: '2',
      userId: '154',
      venueId: '456',
      bookingDate: DateTime(2025, 03, 10),
      status: 'confirmed',
      userName: 'bib lamsal',
      userEmail: 'bibhakta4@gmail.com',
      userPhone: '+977 986754643',
      venueName: 'Grand Hall',
      venueImages: ['image1.jpg'],
      venuePrice: 10000.0,
      venueCapacity: 500,
    ),
  ];

  /// Should return a list of user bookings when the call is successful**
  test('should return a list of user bookings from the repository', () async {
    // Arrange: Mock repository response
    when(() => mockBookingRepository.getUserBookings())
        .thenAnswer((_) async => tBookings);

    // Act: Call the use case
    final result = await useCase();

    // Assert: Check if the response matches expected bookings
    expect(result, equals(tBookings));
    verify(() => mockBookingRepository.getUserBookings()).called(1);
    verifyNoMoreInteractions(mockBookingRepository);
  });

  /// Should return an empty list if no bookings exist**
  test('should return an empty list if there are no user bookings', () async {
    // Arrange: Mock repository response with empty list
    when(() => mockBookingRepository.getUserBookings())
        .thenAnswer((_) async => []);

    // Act: Call the use case
    final result = await useCase();

    // Assert: Check if the response is an empty list
    expect(result, isEmpty);
    verify(() => mockBookingRepository.getUserBookings()).called(1);
    verifyNoMoreInteractions(mockBookingRepository);
  });

  /// Should throw an exception when repository fails**
  test('should throw an exception when repository call fails', () async {
    // Arrange: Simulate an exception from the repository
    when(() => mockBookingRepository.getUserBookings())
        .thenThrow(Exception('Failed to fetch bookings'));

    // Act & Assert: Verify exception is thrown
    expect(() => useCase(), throwsException);
    verify(() => mockBookingRepository.getUserBookings()).called(1);
    verifyNoMoreInteractions(mockBookingRepository);
  });
}
