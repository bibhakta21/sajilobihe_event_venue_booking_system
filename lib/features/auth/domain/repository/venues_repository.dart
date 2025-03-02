import 'package:dartz/dartz.dart';
import 'package:sajilobihe_event_venue_booking_system/core/error/failure.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/domain/entity/venue_entity.dart';


abstract class VenueRepository {
  Future<Either<Failure, List<VenueEntity>>> getAllVenues();
  Future<Either<Failure, void>> addVenue(VenueEntity venue);
  Future<Either<Failure, void>> updateVenue(String id, VenueEntity venue);
  Future<Either<Failure, void>> deleteVenue(String id);
}
