// 2 unit test for delelte usecase

// test/delete_user_usecase_test.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sajilobihe_event_venue_booking_system/core/error/failure.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/domain/repository/user_repository.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/domain/use_case/delete_user_usecase.dart';

/// Create a mock for IUserRepository
class MockUserRepository extends Mock implements IUserRepository {}

void main() {
  late DeleteUserUsecase usecase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = DeleteUserUsecase(userRepository: mockUserRepository);
  });

  const tUserId = "123";

  test('should return Right(null) when delete user is successful', () async {
    // Arrange
    when(() => mockUserRepository.deleteUser(tUserId))
        .thenAnswer((_) async => Right(null));

    // Act
    final result = await usecase(DeleteUserParams(userId: tUserId));

    // Assert
    expect(result, right(null));
    verify(() => mockUserRepository.deleteUser(tUserId)).called(1);
    verifyNoMoreInteractions(mockUserRepository);
  });

  test('should return Left(ApiFailure) when delete user fails', () async {
    // Arrange
    final tFailure = ApiFailure(statusCode: 400, message: "Deletion failed");
    when(() => mockUserRepository.deleteUser(tUserId))
        .thenAnswer((_) async => Left(tFailure));

    // Act
    final result = await usecase(DeleteUserParams(userId: tUserId));

    // Assert
    expect(result, Left(tFailure));
    verify(() => mockUserRepository.deleteUser(tUserId)).called(1);
    verifyNoMoreInteractions(mockUserRepository);
  });
}
