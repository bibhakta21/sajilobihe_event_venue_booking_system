//3 widget test
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sajilobihe_event_venue_booking_system/features/contact_us/domain/entity/contact_entity.dart';
import 'package:sajilobihe_event_venue_booking_system/features/contact_us/presentation/view/contact_view.dart';

import 'package:sajilobihe_event_venue_booking_system/features/contact_us/presentation/view_model/user/contact_bloc_view.dart';
import 'package:sajilobihe_event_venue_booking_system/features/contact_us/presentation/view_model/user/contact_event.dart';
import 'package:sajilobihe_event_venue_booking_system/features/contact_us/presentation/view_model/user/contact_state.dart';

/// Mock ContactBlocView
class MockContactBloc extends MockBloc<ContactEvent, ContactState>
    implements ContactBlocView {}

/// Fake ContactEvent for fallback
class FakeContactEvent extends Fake implements ContactEvent {}

///  Fake ContactEntity
class FakeContactEntity extends Fake implements ContactEntity {}

void main() {
  late MockContactBloc contactBloc;

  setUpAll(() {
    // Register fake event & entity for mocktail
    registerFallbackValue(FakeContactEvent());
    registerFallbackValue(FakeContactEntity());
  });

  setUp(() {
    contactBloc = MockContactBloc();
    when(() => contactBloc.state).thenReturn(ContactInitialState());
  });

  ///  Wraps ContactView with MaterialApp & BlocProvider
  Widget loadContactScreen() {
    return BlocProvider<ContactBlocView>.value(
      value: contactBloc,
      child: const MaterialApp(
        home: ContactView(),
      ),
    );
  }

  ///  Should display "Contact Us" title**
  testWidgets('should display "Contact Us" title', (WidgetTester tester) async {
    await tester.pumpWidget(loadContactScreen());
    await tester.pumpAndSettle();

    expect(find.text('Contact Us'), findsOneWidget);
  });



  /// Should display text fields for name, email, phone, and message**
  testWidgets('should display text fields for name, email, phone, and message',
      (WidgetTester tester) async {
    await tester.pumpWidget(loadContactScreen());
    await tester.pumpAndSettle();

    expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is TextField && widget.decoration?.labelText == 'Full Name',
        ),
        findsOneWidget);
    expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is TextField && widget.decoration?.labelText == 'Email',
        ),
        findsOneWidget);
    expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is TextField && widget.decoration?.labelText == 'Phone',
        ),
        findsOneWidget);
    expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is TextField && widget.decoration?.labelText == 'Your Message',
        ),
        findsOneWidget);
  });

  /// Should display Submit button**
  testWidgets('should display Submit button', (WidgetTester tester) async {
    await tester.pumpWidget(loadContactScreen());
    await tester.pumpAndSettle();

    expect(find.widgetWithText(ElevatedButton, 'Submit'), findsOneWidget);
  });

  /// Should show error messages when submitting empty form**
  
}
