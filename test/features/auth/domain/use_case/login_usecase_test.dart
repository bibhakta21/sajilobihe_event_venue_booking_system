//4 unit test login usecase
// test/login_usecase_test.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sajilobihe_event_venue_booking_system/app/shared_prefs/token_shared_prefs.dart';
import 'package:sajilobihe_event_venue_booking_system/core/error/failure.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/domain/use_case/login_usecase.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/domain/repository/user_repository.dart';

/// Create mocks using mocktail.
class MockUserRepository extends Mock implements IUserRepository {}

class MockTokenSharedPrefs extends Mock implements TokenSharedPrefs {}

void main() {
  late LoginUsecase usecase;
  late MockUserRepository mockUserRepository;
  late MockTokenSharedPrefs mockTokenSharedPrefs;

  setUpAll(() {
    // Register fallback value for LoginParams
    registerFallbackValue(LoginParams(email: '', password: ''));
  });

  setUp(() {
    mockUserRepository = MockUserRepository();
    mockTokenSharedPrefs = MockTokenSharedPrefs();
    usecase = LoginUsecase(mockUserRepository, mockTokenSharedPrefs);
  });

  const tEmail = 'bibhakta@gmail.com';
  const tPassword = 'bibhakta';
  const tToken = 'some_token';

  test('should return token when login is successful', () async {
    // Arrange
    when(() => mockUserRepository.loginUser(tEmail, tPassword))
        .thenAnswer((_) async => const Right(tToken));
    when(() => mockTokenSharedPrefs.saveToken(tToken))
        .thenAnswer((_) async => const Right(null));
    when(() => mockTokenSharedPrefs.getToken())
        .thenAnswer((_) async => const Right(tToken));

    // Act
    final result = await usecase(LoginParams(email: tEmail, password: tPassword));

    // Assert
    expect(result, const Right(tToken));
    verify(() => mockUserRepository.loginUser(tEmail, tPassword)).called(1);
    verify(() => mockTokenSharedPrefs.saveToken(tToken)).called(1);
    verify(() => mockTokenSharedPrefs.getToken()).called(1);
    verifyNoMoreInteractions(mockUserRepository);
    verifyNoMoreInteractions(mockTokenSharedPrefs);
  });

  test('should return failure when login fails', () async {
    // Arrange
    final tFailure = ApiFailure(statusCode: 400, message: 'Invalid credentials');
    when(() => mockUserRepository.loginUser(tEmail, tPassword))
        .thenAnswer((_) async => Left(tFailure));

    // Act
    final result = await usecase(LoginParams(email: tEmail, password: tPassword));

    // Assert
    expect(result, Left(tFailure));
    verify(() => mockUserRepository.loginUser(tEmail, tPassword)).called(1);
    verifyNoMoreInteractions(mockUserRepository);
    // No token saving or retrieval should occur in failure.
  });

  test('should return token even if saving token fails', () async {
    // Arrange: Repository returns token successfully, but saveToken fails.
    when(() => mockUserRepository.loginUser(tEmail, tPassword))
        .thenAnswer((_) async => const Right(tToken));
    when(() => mockTokenSharedPrefs.saveToken(tToken))
        .thenAnswer((_) async => Left(ApiFailure(statusCode: 500, message: 'Save failed')));
    // Even if getToken is called, we simulate it returning the token.
    when(() => mockTokenSharedPrefs.getToken())
        .thenAnswer((_) async => const Right(tToken));

    // Act
    final result = await usecase(LoginParams(email: tEmail, password: tPassword));

    // Assert: The use case should still return the token.
    expect(result, const Right(tToken));
    verify(() => mockUserRepository.loginUser(tEmail, tPassword)).called(1);
    verify(() => mockTokenSharedPrefs.saveToken(tToken)).called(1);
    verify(() => mockTokenSharedPrefs.getToken()).called(1);
  });

  test('should return token even if retrieving token fails', () async {
    // Arrange: Repository returns token, saveToken succeeds, but getToken fails.
    when(() => mockUserRepository.loginUser(tEmail, tPassword))
        .thenAnswer((_) async => const Right(tToken));
    when(() => mockTokenSharedPrefs.saveToken(tToken))
        .thenAnswer((_) async => const Right(null));
    when(() => mockTokenSharedPrefs.getToken())
        .thenAnswer((_) async => Left(ApiFailure(statusCode: 500, message: 'Get failed')));

    // Act
    final result = await usecase(LoginParams(email: tEmail, password: tPassword));

    // Assert: Based on your current usecase, the result should still be Right(tToken)
    expect(result, const Right(tToken));
    verify(() => mockUserRepository.loginUser(tEmail, tPassword)).called(1);
    verify(() => mockTokenSharedPrefs.saveToken(tToken)).called(1);
    verify(() => mockTokenSharedPrefs.getToken()).called(1);
  });
}
