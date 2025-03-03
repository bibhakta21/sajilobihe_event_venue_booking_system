import 'package:sajilobihe_event_venue_booking_system/features/venue/data/data_source/remote_datasource/venues_remote_datasource.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/domain/entity/venue.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/domain/repository/venue_repository_final.dart';

/// Repository implementation that delegates calls to the remote data source.
class VenueRepositoryImpl implements VenueRepository {
  final VenueRemoteDataSource remoteDataSource;

  VenueRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Venue>> getAllVenues() async {
    final venues = await remoteDataSource.getAllVenues();
    return venues;
  }

  @override
  Future<Venue> getVenueById(String id) async {
    final venue = await remoteDataSource.getVenueById(id);
    return venue;
  }

  @override
  Future<Venue> addVenue({
    required String name,
    required String location,
    required int capacity,
    required double price,
    required String description,
    required List<String> images,
  }) async {
    final venueData = {
      'name': name,
      'location': location,
      'capacity': capacity,
      'price': price,
      'description': description,
      'images': images, // List of file paths for images.
    };
    final venue = await remoteDataSource.addVenue(venueData);
    return venue;
  }

  @override
  Future<Venue> updateVenue(
    String id, {
    String? name,
    String? location,
    int? capacity,
    double? price,
    String? description,
    List<String>? images,
    bool? available,
  }) async {
    final venueData = {
      if (name != null) 'name': name,
      if (location != null) 'location': location,
      if (capacity != null) 'capacity': capacity,
      if (price != null) 'price': price,
      if (description != null) 'description': description,
      if (images != null) 'images': images,
      if (available != null) 'available': available,
    };
    final venue = await remoteDataSource.updateVenue(id, venueData);
    return venue;
  }

  @override
  Future<void> deleteVenue(String id) async {
    await remoteDataSource.deleteVenue(id);
  }
}
