import 'package:dartz/dartz.dart';
import 'package:sajilobihe_event_venue_booking_system/core/error/failure.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/data/data_source/remote_datasource/venue_remote_datasource.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/domain/entity/venue_entity.dart';


abstract class VenueRepository {
  Future<Either<Failure, List<VenueEntity>>> getVenues();
}

class VenueRepositoryImpl implements VenueRepository {
  final VenueRemoteDataSource remoteDataSource;

  VenueRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<VenueEntity>>> getVenues() async {
    try {
      final venues = await remoteDataSource.fetchVenues();
      return Right(venues.map((venue) => venue.toEntity()).toList());
    } catch (e) {
      return Left(ApiFailure(message: e.toString(), statusCode: 400));
    }
  }
}
