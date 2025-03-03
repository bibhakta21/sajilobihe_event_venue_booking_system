import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/domain/entity/venue_entity.dart';
import 'venue_event.dart';
import 'venue_state.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/domain/use_case/get_all_venues_usecase.dart';

class VenueBloc extends Bloc<VenueEvent, VenueState> {
  final GetVenuesUseCase _getVenuesUseCase;
  List<VenueEntity> _allVenues = [];

  VenueBloc(this._getVenuesUseCase) : super(VenueLoadingState()) {
    on<LoadVenuesEvent>((event, emit) async {
      emit(VenueLoadingState());
      final result = await _getVenuesUseCase();
      result.fold(
        (failure) => emit(VenueErrorState(failure.message)),
        (venues) {
          _allVenues = venues;
          emit(VenueLoadedState(venues));
        },
      );
    });

    on<SearchVenueEvent>((event, emit) {
      final filteredVenues = _allVenues
          .where((venue) => venue.name.toLowerCase().contains(event.query.toLowerCase()))
          .toList();
      emit(VenueLoadedState(filteredVenues));
    });
  }
}
