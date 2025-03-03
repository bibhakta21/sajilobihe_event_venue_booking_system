// test/login_view_widget_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/presentation/view/login_view.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/presentation/view_model/login/login_state.dart';

/// Create a mock LoginBloc using mocktail and bloc_test.
class MockLoginBloc extends MockBloc<LoginEvent, LoginState>
    implements LoginBloc {}

void main() {
  late MockLoginBloc loginBloc;

  setUp(() {
    loginBloc = MockLoginBloc();
    when(() => loginBloc.state).thenReturn(LoginState.initial());
  });

  /// A helper to wrap the widget under test with necessary MaterialApp & BlocProvider.
  Widget loadLoginScreen() {
    return BlocProvider<LoginBloc>.value(
      value: loginBloc,
      child: MaterialApp(
        home: LoginView(),
      ),
    );
  }

  testWidgets('should display the Login button', (WidgetTester tester) async {
    await tester.pumpWidget(loadLoginScreen());
    await tester.pumpAndSettle();

    // Verify that the button with text "Login" is present.
    final loginButton = find.widgetWithText(ElevatedButton, 'Login');
    expect(loginButton, findsOneWidget);
  });

  testWidgets('should allow entering email and password', (WidgetTester tester) async {
    await tester.pumpWidget(loadLoginScreen());
    await tester.pumpAndSettle();

    // Locate the TextFields using their hintText.
    final emailField = find.byWidgetPredicate(
      (widget) =>
          widget is TextField &&
          widget.decoration?.hintText == 'Enter your email',
    );
    final passwordField = find.byWidgetPredicate(
      (widget) =>
          widget is TextField && widget.decoration?.hintText == 'Password',
    );
    
    expect(emailField, findsOneWidget);
    expect(passwordField, findsOneWidget);

    // Enter text into the email and password fields.
    await tester.enterText(emailField, 'test@example.com');
    await tester.enterText(passwordField, 'password');

    // Verify the text is entered.
    expect(find.text('test@example.com'), findsOneWidget);
    expect(find.text('password'), findsOneWidget);
  });

  testWidgets('should display "Forgot password?" text', (WidgetTester tester) async {
    await tester.pumpWidget(loadLoginScreen());
    await tester.pumpAndSettle();

    final forgotPasswordText = find.text("Forgot password?");
    expect(forgotPasswordText, findsOneWidget);
  });

  testWidgets('should display "New Member? Register now" text button', (WidgetTester tester) async {
    await tester.pumpWidget(loadLoginScreen());
    await tester.pumpAndSettle();

    // Check that the "New Member?" text exists.
    expect(find.text("New Member? "), findsOneWidget);
    // And the "Register now" TextButton is present.
    final registerButton = find.widgetWithText(TextButton, "Register now");
    expect(registerButton, findsOneWidget);
  });
}
