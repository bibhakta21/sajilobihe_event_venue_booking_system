import 'package:equatable/equatable.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/domain/entity/venue_entity.dart';

abstract class VenueState extends Equatable {
  @override
  List<Object> get props => [];
}

class VenueLoadingState extends VenueState {}

class VenueLoadedState extends VenueState {
  final List<VenueEntity> venues;

  VenueLoadedState(this.venues);

  @override
  List<Object> get props => [venues];
}

class VenueErrorState extends VenueState {
  final String message;

  VenueErrorState(this.message);

  @override
  List<Object> get props => [message];
}
