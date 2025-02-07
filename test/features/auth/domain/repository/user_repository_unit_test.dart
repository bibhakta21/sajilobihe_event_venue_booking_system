import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sajilobihe_event_venue_booking_system/app/shared_prefs/token_shared_prefs.dart';
import 'package:sajilobihe_event_venue_booking_system/core/error/failure.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/domain/entity/user_entity.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/domain/repository/user_repository.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/domain/use_case/create_user_usecase.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/domain/use_case/delete_user_usecase.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/domain/use_case/get_all_user_usecase.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/domain/use_case/login_usecase.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/domain/use_case/upload_image_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Mock classes
class MockUserRepository extends Mock implements IUserRepository {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

// Define a Fake for UserEntity
class FakeUserEntity extends Fake implements UserEntity {}

void main() {
  late MockUserRepository mockUserRepository;
  late TokenSharedPrefs tokenSharedPrefs;
  late MockSharedPreferences mockSharedPreferences;

  setUpAll(() {
    registerFallbackValue(FakeUserEntity()); // Register fallback for UserEntity
  });

  setUp(() {
    mockUserRepository = MockUserRepository();
    mockSharedPreferences = MockSharedPreferences();
    tokenSharedPrefs = TokenSharedPrefs(mockSharedPreferences);
  });

  // 1. Test Create User Use Case
  test('should call createUser method from repository', () async {
    final createUserUsecase =
        CreateUserUsecase(userRepository: mockUserRepository);
    const user = UserEntity(
      fullName: 'Bibhakta Lamsal',
      email: 'bibhakta@gmail.com',
      password: 'password123',
      phone: '9813056161',
      address: 'kalanki',
      role: 'user',
    );

    when(() => mockUserRepository.createUser(any()))
        .thenAnswer((_) async => const Right(null));

    final result = await createUserUsecase.call(CreateUserParams(
      fullName: user.fullName,
      email: user.email,
      password: user.password,
      phone: user.phone,
      address: user.address,
      role: user.role,
    ));

    expect(result, equals(const Right(null)));
    verify(() => mockUserRepository.createUser(any())).called(1);
  });

  // 2. Test Delete User Use Case
  test('should call deleteUser method from repository', () async {
    final deleteUserUsecase =
        DeleteUserUsecase(userRepository: mockUserRepository);
    const userId = '123';

    when(() => mockUserRepository.deleteUser(userId))
        .thenAnswer((_) async => const Right(null));

    final result =
        await deleteUserUsecase.call(const DeleteUserParams(userId: userId));

    expect(result, equals(const Right(null)));
    verify(() => mockUserRepository.deleteUser(userId)).called(1);
  });

  // 3. Test Get All Users Use Case
  test('should return a list of users', () async {
    final getAllUsersUsecase =
        GetAllUserUsecase(userRepository: mockUserRepository);
    final users = [
      const UserEntity(
          fullName: 'Bibhakta Lamsal',
          email: 'bibhakta@gmail.com',
          password: '',
          phone: '',
          address: '',
          role: 'user'),
      const UserEntity(
          fullName: 'Bibhakta Lamsal',
          email: 'bibhakta@gmail.com',
          password: '',
          phone: '',
          address: '',
          role: 'user'),
    ];

    when(() => mockUserRepository.getAllUsers())
        .thenAnswer((_) async => Right(users));

    final result = await getAllUsersUsecase.call();

    expect(result, equals(Right(users)));
    verify(() => mockUserRepository.getAllUsers()).called(1);
  });

  // 4. Test Login Use Case
  test('should save token after successful login', () async {
    final loginUsecase = LoginUsecase(mockUserRepository, tokenSharedPrefs);
    const email = 'bibhakta@gmail.com';
    const password = 'password123';
    const token = 'mocked_token';

    when(() => mockUserRepository.loginUser(email, password))
        .thenAnswer((_) async => const Right(token));
    when(() => mockSharedPreferences.setString('token', token))
        .thenAnswer((_) async => true);

    final result = await loginUsecase
        .call(const LoginParams(email: email, password: password));

    expect(result, equals(const Right(token)));
    verify(() => mockUserRepository.loginUser(email, password)).called(1);
  });

  // 5. Test Token Shared Preferences - Save Token
  test('should save token to shared preferences', () async {
    const token = 'mock_token';

    when(() => mockSharedPreferences.setString('token', token))
        .thenAnswer((_) async => true);

    final result = await tokenSharedPrefs.saveToken(token);

    expect(result, equals(const Right(null)));
    verify(() => mockSharedPreferences.setString('token', token)).called(1);
  });

  // 6. Test Token Shared Preferences - Get Token
  test('should retrieve token from shared preferences', () async {
    const token = 'mock_token';

    when(() => mockSharedPreferences.getString('token')).thenReturn(token);

    final result = await tokenSharedPrefs.getToken();

    expect(result, equals(const Right(token)));
    verify(() => mockSharedPreferences.getString('token')).called(1);
  });

  // 7. Test Upload Image Use Case
  test('should upload an image', () async {
    final uploadImageUsecase = UploadImageUsecase(mockUserRepository);
    final file = File('path/to/file.jpg');
    const fileName = 'uploaded_image.jpg';

    when(() => mockUserRepository.uploadProfilePicture(file))
        .thenAnswer((_) async => const Right(fileName));

    final result = await uploadImageUsecase.call(UploadImageParams(file: file));

    expect(result, equals(const Right(fileName)));
    verify(() => mockUserRepository.uploadProfilePicture(file)).called(1);
  });

  // 8. Test Failure Handling in Repository
  test('should return failure when repository throws an error', () async {
    final getAllUsersUsecase =
        GetAllUserUsecase(userRepository: mockUserRepository);

    when(() => mockUserRepository.getAllUsers()).thenAnswer((_) async =>
        const Left(ApiFailure(statusCode: 500, message: 'Server error')));

    final result = await getAllUsersUsecase.call();

    expect(
        result,
        equals(
            const Left(ApiFailure(statusCode: 500, message: 'Server error'))));
  });

  // 9. Test Invalid User ID Failure
  test('should return failure when user ID is invalid', () async {
    final deleteUserUsecase =
        DeleteUserUsecase(userRepository: mockUserRepository);

    when(() => mockUserRepository.deleteUser('')).thenAnswer(
        (_) async => const Left(SharedPrefsFailure(message: 'Invalid ID')));

    final result =
        await deleteUserUsecase.call(const DeleteUserParams(userId: ''));

    expect(
        result, equals(const Left(SharedPrefsFailure(message: 'Invalid ID'))));
  });


// 10. Test Invalid login credential
   test('should return failure when login credentials are incorrect', () async {
    final loginUsecase = LoginUsecase(mockUserRepository, tokenSharedPrefs);
    const email = 'wrongemail@gmail.com';
    const password = 'wrongpassword';

    when(() => mockUserRepository.loginUser(email, password)).thenAnswer(
        (_) async => const Left(ApiFailure(statusCode: 401, message: 'Invalid credentials')));

    final result = await loginUsecase.call(const LoginParams(email: email, password: password));

    expect(result, equals(const Left(ApiFailure(statusCode: 401, message: 'Invalid credentials'))));
    verify(() => mockUserRepository.loginUser(email, password)).called(1);
  });
}
