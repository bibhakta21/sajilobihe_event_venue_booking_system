// 2 unit test
// test/get_all_contacts_usecase_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sajilobihe_event_venue_booking_system/features/contact_us/domain/entity/contact_entity.dart';
import 'package:sajilobihe_event_venue_booking_system/features/contact_us/domain/repository/contact_repository.dart';
import 'package:sajilobihe_event_venue_booking_system/features/contact_us/domain/use_case/get_all_contact_usecase.dart';

class MockContactRepository extends Mock implements ContactRepository {}

void main() {
  late GetAllContactsUseCase usecase;
  late MockContactRepository mockContactRepository;

  setUp(() {
    mockContactRepository = MockContactRepository();
    usecase = GetAllContactsUseCase(mockContactRepository);
  });

  final tContacts = [
    ContactEntity(
      id: '1',
      name: 'bibhakta',
      email: 'bibhakta@gmail.com',
      phone: '1234567890',
      message: 'Hello',
    ),
    ContactEntity(
      id: '2',
      name: 'bibhakta1',
      email: 'bibhakta@gmail.com',
      phone: '1234567890',
      message: 'Hello',
    ),
  ];

  test('should return a list of contacts when successful', () async {
    // Arrange
    when(() => mockContactRepository.getAllContacts())
        .thenAnswer((_) async => tContacts);

    // Act
    final result = await usecase();

    // Assert
    expect(result, tContacts);
    verify(() => mockContactRepository.getAllContacts()).called(1);
    verifyNoMoreInteractions(mockContactRepository);
  });

  test('should throw an exception when fetching contacts fails', () async {
    // Arrange
    when(() => mockContactRepository.getAllContacts())
        .thenThrow(Exception('Failed to fetch contacts'));

    // Act & Assert
    expect(() => usecase(), throwsException);
    verify(() => mockContactRepository.getAllContacts()).called(1);
    verifyNoMoreInteractions(mockContactRepository);
  });
}
