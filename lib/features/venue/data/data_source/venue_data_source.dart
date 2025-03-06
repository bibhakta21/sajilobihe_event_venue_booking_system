import 'package:sajilobihe_event_venue_booking_system/features/venue/domain/entity/venue_entity.dart';

abstract class IVenueDataSource {
  Future<void> cacheVenues(List<VenueEntity> venues);
  Future<List<VenueEntity>> getCachedVenues();
  Future<void> clearCachedVenues();
}
