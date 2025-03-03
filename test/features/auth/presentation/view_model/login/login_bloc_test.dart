import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/data/data_source/remote_datasource/user_profile_service.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/domain/use_case/login_usecase.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/presentation/view_model/login/login_state.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/presentation/view_model/signup/register_bloc.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/presentation/view_model/signup/register_state.dart';

/// Mock Dependencies
class MockLoginUsecase extends Mock implements LoginUsecase {}

class MockUserProfileService extends Mock implements UserProfileService {}

class MockRegisterBloc extends MockBloc<RegisterEvent, RegisterState>
    implements RegisterBloc {}

void main() {
  late LoginBloc loginBloc;
  late MockLoginUsecase mockLoginUsecase;
  late MockUserProfileService mockUserProfileService;
  late MockRegisterBloc mockRegisterBloc;

  setUp(() {
    mockLoginUsecase = MockLoginUsecase();
    mockUserProfileService = MockUserProfileService();
    mockRegisterBloc = MockRegisterBloc();

    when(() => mockRegisterBloc.state).thenReturn(RegisterState.initial());

    loginBloc = LoginBloc(
      registerBloc: mockRegisterBloc,
      loginUsecase: mockLoginUsecase,
      userProfileService: mockUserProfileService,
    );
  });

  tearDown(() {
    loginBloc.close();
  });

  const testEmail = "test@example.com";
  const testPassword = "password123";
  const testToken = "mock_token";

  final testLoginParams = LoginParams(email: testEmail, password: testPassword);

  /// Initial State**
  testWidgets("Initial state should be LoginState.initial()",
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: Builder(builder: (context) {
        return BlocProvider.value(
          value: loginBloc,
          child: Container(), // Just a dummy widget
        );
      })),
    ));

    expect(loginBloc.state, equals(LoginState.initial()));
  });
}

///Fixing the ScaffoldMessenger issue**
class MockContextWithScaffold extends Mock implements BuildContext {
  @override
  ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessengerState();
}
