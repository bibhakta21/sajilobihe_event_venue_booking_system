
import 'package:sajilobihe_event_venue_booking_system/features/venue/domain/entity/venue.dart';

abstract class VenueRepository {
  Future<List<Venue>> getAllVenues();
  Future<Venue> getVenueById(String id);
  Future<Venue> addVenue({
    required String name,
    required String location,
    required int capacity,
    required double price,
    required String description,
    required List<String> images,
  });
  Future<Venue> updateVenue(String id, {
    String? name,
    String? location,
    int? capacity,
    double? price,
    String? description,
    List<String>? images,
    bool? available,
  });
  Future<void> deleteVenue(String id);
}
