import 'package:sajilobihe_event_venue_booking_system/core/network/hive_service.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/data/data_source/venue_data_source.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/data/model/venue_hive_model.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/domain/entity/venue_entity.dart';

class VenueLocalDataSource implements IVenueDataSource {
  final HiveService _hiveService;

  VenueLocalDataSource(this._hiveService);

  @override
  Future<void> cacheVenues(List<VenueEntity> venues) async {
    try {
      final venueModels =
          venues.map((e) => VenueHiveModel.fromEntity(e)).toList();
      await _hiveService.storeVenues(venueModels);
    } catch (e) {
      throw Exception("Failed to cache venues: $e");
    }
  }

  @override
  Future<List<VenueEntity>> getCachedVenues() async {
    try {
      final venues = await _hiveService.getStoredVenues();
      return venues.map((e) => e.toEntity()).toList();
    } catch (e) {
      throw Exception("Failed to retrieve cached venues: $e");
    }
  }

  @override
  Future<void> clearCachedVenues() async {
    try {
      await _hiveService.clearVenues();
    } catch (e) {
      throw Exception("Failed to clear cached venues: $e");
    }
  }
}
