import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/domain/use_case/create_venue.usecase.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/domain/use_case/delete_venue_usecase.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/domain/use_case/get_all_venue_usecase.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/domain/use_case/update_venue_usecase.dart';
import 'venue_event.dart';
import 'venue_state.dart';


class VenueBloc extends Bloc<VenueEvent, VenueState> {
  final GetAllVenuesUseCase getAllVenuesUseCase;
  final AddVenueUseCase addVenueUseCase;
  final UpdateVenueUseCase updateVenueUseCase;
  final DeleteVenueUseCase deleteVenueUseCase;

  VenueBloc({
    required this.getAllVenuesUseCase,
    required this.addVenueUseCase,
    required this.updateVenueUseCase,
    required this.deleteVenueUseCase,
  }) : super(VenueInitial()) {
    on<LoadVenues>(_onLoadVenues);
    on<AddVenueEvent>(_onAddVenue);
    on<UpdateVenueEvent>(_onUpdateVenue);
    on<DeleteVenueEvent>(_onDeleteVenue);
  }

  Future<void> _onLoadVenues(LoadVenues event, Emitter<VenueState> emit) async {
    emit(VenueLoading());
    try {
      final venues = await getAllVenuesUseCase();
      emit(VenueLoaded(venues));
    } catch (e) {
      emit(VenueError(e.toString()));
    }
  }

  Future<void> _onAddVenue(AddVenueEvent event, Emitter<VenueState> emit) async {
    emit(VenueLoading());
    try {
      await addVenueUseCase(
        name: event.name,
        location: event.location,
        capacity: event.capacity,
        price: event.price,
        description: event.description,
        images: event.images,
      );
      emit(VenueOperationSuccess("Venue added successfully"));
      add(LoadVenues());
    } catch (e) {
      emit(VenueError(e.toString()));
    }
  }

  Future<void> _onUpdateVenue(UpdateVenueEvent event, Emitter<VenueState> emit) async {
    emit(VenueLoading());
    try {
      await updateVenueUseCase(
        event.id,
        name: event.name,
        location: event.location,
        capacity: event.capacity,
        price: event.price,
        description: event.description,
        images: event.images,
        available: event.available,
      );
      emit(VenueOperationSuccess("Venue updated successfully"));
      add(LoadVenues());
    } catch (e) {
      emit(VenueError(e.toString()));
    }
  }

  Future<void> _onDeleteVenue(DeleteVenueEvent event, Emitter<VenueState> emit) async {
    emit(VenueLoading());
    try {
      await deleteVenueUseCase(event.id);
      emit(VenueOperationSuccess("Venue deleted successfully"));
      add(LoadVenues());
    } catch (e) {
      emit(VenueError(e.toString()));
    }
  }
}
