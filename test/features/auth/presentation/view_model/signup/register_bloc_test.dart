import 'dart:io';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sajilobihe_event_venue_booking_system/core/error/failure.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/domain/use_case/create_user_usecase.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/domain/use_case/upload_image_usecase.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/presentation/view_model/signup/register_bloc.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/presentation/view_model/signup/register_state.dart';

class MockCreateUserUsecase extends Mock implements CreateUserUsecase {}

class MockUploadImageUsecase extends Mock implements UploadImageUsecase {}

void main() {
  late RegisterBloc registerBloc;
  late MockCreateUserUsecase mockCreateUserUsecase;
  late MockUploadImageUsecase mockUploadImageUsecase;

  setUpAll(() {
    registerFallbackValue(CreateUserParams(
      fullName: '',
      email: '',
      password: '',
      phone: '',
      address: '',
      avatar: '',
      role: '',
    ));
    registerFallbackValue(UploadImageParams(file: File('')));
  });

  setUp(() {
    mockCreateUserUsecase = MockCreateUserUsecase();
    mockUploadImageUsecase = MockUploadImageUsecase();
    registerBloc = RegisterBloc(
      createUserUsecase: mockCreateUserUsecase,
      uploadImageUsecase: mockUploadImageUsecase,
    );
  });

  tearDown(() {
    registerBloc.close();
  });

  // ✅ Test 1: Initial state
  test('Initial state should be RegisterState.initial()', () {
    expect(registerBloc.state, RegisterState.initial());
  });

 

  // ✅ Test 2: Bloc should not emit new states after disposal
  test('RegisterBloc does not emit new states after being closed', () {
    expectLater(
      registerBloc.stream,
      emitsDone,
    );
    registerBloc.close();
  });

  // ✅ Test 3: Bloc should not emit new states without any event
  test('RegisterBloc does not emit new states when no event is added', () {
    expectLater(
      registerBloc.stream,
      emitsInOrder([]),
    );
  });

   // ✅ Test 4: Image Upload Success
  blocTest<RegisterBloc, RegisterState>(
    'emits [loading, success] when LoadImage succeeds',
    build: () {
      when(() => mockUploadImageUsecase.call(any())).thenAnswer(
        (_) async => Right('image.png'),
      );
      return registerBloc;
    },
    act: (bloc) => bloc.add(LoadImage(file: File('test.png'))),
    expect: () => [
      RegisterState(isLoading: true, isSuccess: false),
      RegisterState(isLoading: false, isSuccess: true, imageName: 'image.png'),
    ],
  );

  // ✅ Test 5: Image Upload Failure
  blocTest<RegisterBloc, RegisterState>(
    'emits [loading, failure] when LoadImage fails',
    build: () {
      when(() => mockUploadImageUsecase.call(any())).thenAnswer(
        (_) async => Left(ApiFailure(message: 'Upload Error', statusCode: 500)),
      );
      return registerBloc;
    },
    act: (bloc) => bloc.add(LoadImage(file: File('test.png'))),
    expect: () => [
      RegisterState(isLoading: true, isSuccess: false),
      RegisterState(isLoading: false, isSuccess: false),
    ],
  );
}
