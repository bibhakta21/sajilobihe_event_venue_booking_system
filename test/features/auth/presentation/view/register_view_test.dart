import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/presentation/view/register_view.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/presentation/view_model/signup/register_bloc.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/presentation/view_model/signup/register_state.dart';

/// Create a mock for RegisterBloc
class MockRegisterBloc extends MockBloc<RegisterEvent, RegisterState>
    implements RegisterBloc {}

/// Create a fake BuildContext for testing
class FakeBuildContext extends Fake implements BuildContext {}

void main() {
  late MockRegisterBloc registerBloc;

  setUpAll(() {
    registerFallbackValue(FakeBuildContext()); // Register fake context
    registerFallbackValue(RegisterUserEvent(
      context: FakeBuildContext(), // Use fake context
      fullName: '',
      email: '',
      password: '',
    ));
    registerFallbackValue(LoadImage(file: File('dummy.png'))); // Use dummy file
  });

  setUp(() {
    registerBloc = MockRegisterBloc();
    when(() => registerBloc.state).thenReturn(RegisterState.initial());
  });

  /// A helper widget to wrap RegisterView in MaterialApp and BlocProvider.
  Widget loadRegisterScreen() {
    return BlocProvider<RegisterBloc>.value(
      value: registerBloc,
      child: const MaterialApp(
        home: RegisterView(),
      ),
    );
  }

  testWidgets('should display logo, "Get Started" text and "Sign Up" button',
      (WidgetTester tester) async {
    await tester.pumpWidget(loadRegisterScreen());
    await tester.pumpAndSettle();

    expect(find.byType(Image), findsWidgets);
    expect(find.text('Get Started'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Sign Up'), findsOneWidget);
  });

  testWidgets('should display text fields for fullname, email, and password',
      (WidgetTester tester) async {
    await tester.pumpWidget(loadRegisterScreen());
    await tester.pumpAndSettle();

    expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is TextField &&
              widget.decoration?.hintText == 'Enter your fullname',
        ),
        findsOneWidget);
    expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is TextField &&
              widget.decoration?.hintText == 'Enter your email',
        ),
        findsOneWidget);
    expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is TextField &&
              widget.decoration?.hintText == 'Secured Password',
        ),
        findsOneWidget);
  });

  ///  Check if "Already a member? Log in" is displayed
  testWidgets('should display "Already a member? Log in" text',
      (WidgetTester tester) async {
    await tester.pumpWidget(loadRegisterScreen());
    await tester.pumpAndSettle();

    expect(find.text("Already a member? Log in"), findsOneWidget);
  });

  

  ///  Should show bottom sheet when profile picture is tapped
  testWidgets('should show bottom sheet when profile picture is tapped',
      (WidgetTester tester) async {
    await tester.pumpWidget(loadRegisterScreen());
    await tester.pumpAndSettle();

    // Tap on the profile picture placeholder (Avatar)
    await tester.tap(find.byType(CircleAvatar));
    await tester.pumpAndSettle();

    // Check if bottom sheet is shown
    expect(find.text('Camera'), findsOneWidget);
    expect(find.text('Gallery'), findsOneWidget);
  });

}
