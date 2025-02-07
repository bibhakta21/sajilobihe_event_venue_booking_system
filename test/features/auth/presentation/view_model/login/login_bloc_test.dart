import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sajilobihe_event_venue_booking_system/core/error/failure.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/domain/use_case/login_usecase.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/presentation/view_model/login/login_state.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/presentation/view_model/signup/register_bloc.dart';
import 'package:sajilobihe_event_venue_booking_system/features/home/presentation/view_model/home_cubit.dart';

class MockLoginUsecase extends Mock implements LoginUsecase {}

class MockRegisterBloc extends Mock implements RegisterBloc {}

class MockHomeCubit extends Mock implements HomeCubit {}

void main() {
  late LoginBloc loginBloc;
  late MockLoginUsecase mockLoginUsecase;
  late MockRegisterBloc mockRegisterBloc;
  late MockHomeCubit mockHomeCubit;

  setUpAll(() {
    registerFallbackValue(LoginParams(email: '', password: ''));
  });

  setUp(() {
    mockLoginUsecase = MockLoginUsecase();
    mockRegisterBloc = MockRegisterBloc();
    mockHomeCubit = MockHomeCubit();

    loginBloc = LoginBloc(
      registerBloc: mockRegisterBloc,
      homeCubit: mockHomeCubit,
      loginUsecase: mockLoginUsecase,
    );
  });

  tearDown(() {
    loginBloc.close();
  });

  // ✅ Test 1: Initial state should be LoginState.initial()
  test('Initial state should be LoginState.initial()', () {
    expect(loginBloc.state, LoginState.initial());
  });

 blocTest<LoginBloc, LoginState>(
    'emits nothing when no event is added',
    build: () => loginBloc,
    expect: () => [], // No state change expected
  );

  // ✅ Test 3: Emits the initial state when LoginBloc is rebuilt
  blocTest<LoginBloc, LoginState>(
    'emits initial state after being closed and recreated',
    build: () => LoginBloc(
      registerBloc: mockRegisterBloc,
      homeCubit: mockHomeCubit,
      loginUsecase: mockLoginUsecase,
    ),
    expect: () => [],
  );
  
  // ✅ Test 4: Navigation to Register Screen
  testWidgets('does not change state when NavigateRegisterScreenEvent is triggered', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) {
            loginBloc.add(NavigateRegisterScreenEvent(
              context: context,
              destination: Container(),
            ));
            return const SizedBox.shrink();
          },
        ),
      ),
    ));

    await tester.pumpAndSettle(); // Ensure navigation completes

    expect(loginBloc.state, LoginState.initial()); // State should not change
  });

  // ✅ Test 5: Navigation to Home Screen
  testWidgets('does not change state when NavigateHomeScreenEvent is triggered', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) {
            loginBloc.add(NavigateHomeScreenEvent(
              context: context,
              destination: Container(),
            ));
            return const SizedBox.shrink();
          },
        ),
      ),
    ));

    await tester.pumpAndSettle(); // Ensure navigation completes

    expect(loginBloc.state, LoginState.initial()); // State should not change
  });
}
