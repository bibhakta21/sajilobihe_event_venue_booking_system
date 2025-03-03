// test/get_all_user_usecase_test.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sajilobihe_event_venue_booking_system/core/error/failure.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/domain/entity/user_entity.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/domain/repository/user_repository.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/domain/use_case/get_all_user_usecase.dart';

// Create a mock for IUserRepository
class MockUserRepository extends Mock implements IUserRepository {}

void main() {
  late GetAllUserUsecase usecase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = GetAllUserUsecase(userRepository: mockUserRepository);
  });

  final tUserList = [
    UserEntity(
      userId: "1",
      fullName: "Bibhakta Lamsal",
      email: "bibhakta@gmail.com",
      password: "password",
      phone: "9813056161",
      address: "Address 1",
      role: "user",
      avatar: "avatar1.png",
    ),
     UserEntity(
      userId: "2",
      fullName: "Bibhakta Lamsal",
      email: "bibhakta@gmail.com",
      password: "password",
      phone: "9813056161",
      address: "Address 1",
      role: "user",
      avatar: "avatar1.png",
    ),
  ];

  test('should return list of users when getAllUsers is successful', () async {
    // Arrange
    when(() => mockUserRepository.getAllUsers())
        .thenAnswer((_) async => Right(tUserList));

    // Act
    final result = await usecase();

    // Assert
    expect(result, Right(tUserList));
    verify(() => mockUserRepository.getAllUsers()).called(1);
    verifyNoMoreInteractions(mockUserRepository);
  });

  test('should return failure when getAllUsers fails', () async {
    // Arrange
    final tFailure =
        ApiFailure(statusCode: 400, message: "Failed to fetch users");
    when(() => mockUserRepository.getAllUsers())
        .thenAnswer((_) async => Left(tFailure));

    // Act
    final result = await usecase();

    // Assert
    expect(result, Left(tFailure));
    verify(() => mockUserRepository.getAllUsers()).called(1);
    verifyNoMoreInteractions(mockUserRepository);
  });
}
