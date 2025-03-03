// test/delete_contact_usecase_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sajilobihe_event_venue_booking_system/features/contact_us/domain/repository/contact_repository.dart';
import 'package:sajilobihe_event_venue_booking_system/features/contact_us/domain/use_case/delete_contact_usecase.dart';

class MockContactRepository extends Mock implements ContactRepository {}

void main() {
  late DeleteContactUseCase usecase;
  late MockContactRepository mockContactRepository;

  setUp(() {
    mockContactRepository = MockContactRepository();
    usecase = DeleteContactUseCase(mockContactRepository);
  });

  const tId = '123';

  test('should return true when deletion is successful', () async {
    // Arrange
    when(() => mockContactRepository.deleteContact(tId))
        .thenAnswer((_) async => true);

    // Act
    final result = await usecase(tId);

    // Assert
    expect(result, true);
    verify(() => mockContactRepository.deleteContact(tId)).called(1);
    verifyNoMoreInteractions(mockContactRepository);
  });

  test('should throw an exception when deletion fails', () async {
    // Arrange
    when(() => mockContactRepository.deleteContact(tId))
        .thenThrow(Exception('Deletion failed'));

    // Act & Assert
    expect(() => usecase(tId), throwsException);
    verify(() => mockContactRepository.deleteContact(tId)).called(1);
    verifyNoMoreInteractions(mockContactRepository);
  });
}
