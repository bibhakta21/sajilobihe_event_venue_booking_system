// 2 unit test for create user

// test/create_user_usecase_test.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sajilobihe_event_venue_booking_system/core/error/failure.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/domain/entity/user_entity.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/domain/repository/user_repository.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/domain/use_case/create_user_usecase.dart';

// Create a mock for IUserRepository
class MockUserRepository extends Mock implements IUserRepository {}

void main() {
  late CreateUserUsecase usecase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = CreateUserUsecase(userRepository: mockUserRepository);
  });

  const tFullName = 'Bibhakta Lamsal';
  const tEmail = 'bibhakta@gmail.com';
  const tPassword = 'bibhakta';
  const tPhone = '9813056161';
  const tAddress = 'kalanki';
  const tRole = 'user';
  const tAvatar = 'avatar.png';

  final tUserEntity = UserEntity(
    fullName: tFullName,
    email: tEmail,
    password: tPassword,
    phone: tPhone,
    address: tAddress,
    role: tRole,
    avatar: tAvatar,
  );

  final tParams = CreateUserParams(
    fullName: tFullName,
    email: tEmail,
    password: tPassword,
    phone: tPhone,
    address: tAddress,
    role: tRole,
    avatar: tAvatar,
  );

  test('should return Right(null) when create user is successful', () async {
    // Arrange
    when(() => mockUserRepository.createUser(tUserEntity))
        .thenAnswer((_) async => right(null));

    // Act
    final result = await usecase(tParams);

    // Assert
    expect(result, right(null));
    verify(() => mockUserRepository.createUser(tUserEntity)).called(1);
    verifyNoMoreInteractions(mockUserRepository);
  });

  test('should return Left(ApiFailure) when create user fails', () async {
    // Arrange
    final tFailure = ApiFailure(statusCode: 400, message: "Creation failed");
    when(() => mockUserRepository.createUser(tUserEntity))
        .thenAnswer((_) async => left(tFailure));

    // Act
    final result = await usecase(tParams);

    // Assert
    expect(result, left(tFailure));
    verify(() => mockUserRepository.createUser(tUserEntity)).called(1);
    verifyNoMoreInteractions(mockUserRepository);
  });
}
