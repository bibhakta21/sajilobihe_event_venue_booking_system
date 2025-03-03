import 'package:equatable/equatable.dart';

abstract class VenueEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadVenuesEvent extends VenueEvent {}

class SearchVenueEvent extends VenueEvent {
  final String query;

  SearchVenueEvent(this.query);

  @override
  List<Object> get props => [query];
}
