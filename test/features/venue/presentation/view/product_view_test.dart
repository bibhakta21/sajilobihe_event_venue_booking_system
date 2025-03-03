import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/presentation/view/product_view.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/presentation/view_model/user/venue_bloc.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/presentation/view_model/user/venue_event.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/presentation/view_model/user/venue_state.dart';

/// ✅ **Mock VenueBloc**
class MockVenueBloc extends MockBloc<VenueEvent, VenueState>
    implements VenueBloc {}

/// ✅ **Fake VenueEvent & VenueState**
class FakeVenueEvent extends Fake implements VenueEvent {}

class FakeVenueState extends Fake implements VenueState {}

void main() {
  late MockVenueBloc mockVenueBloc;

  setUpAll(() {
    registerFallbackValue(FakeVenueEvent());
    registerFallbackValue(FakeVenueState());
  });

  setUp(() {
    mockVenueBloc = MockVenueBloc();
    when(() => mockVenueBloc.state).thenReturn(VenueLoadingState());
  });

  /// ✅ **Helper function to load Venue Screen**
  Widget loadVenueScreen() {
    return BlocProvider<VenueBloc>.value(
      value: mockVenueBloc,
      child: const MaterialApp(
        home: BookmarkView(),
      ),
    );
  }

  /// ✅ **Test 1: Check if AppBar Title is Present**
  testWidgets('should display AppBar title "Venues"', (WidgetTester tester) async {
    await tester.pumpWidget(loadVenueScreen());
    await tester.pumpAndSettle();

    expect(find.text('Venues'), findsOneWidget);
  });

}
