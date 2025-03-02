import 'package:dartz/dartz.dart';
import 'package:sajilobihe_event_venue_booking_system/core/error/failure.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/domain/entity/venue_entity.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/domain/repository/venue_repository.dart';


class GetVenuesUseCase {
  final VenueRepository repository;

  GetVenuesUseCase(this.repository);

  Future<Either<Failure, List<VenueEntity>>> call() async {
    return repository.getVenues();
  }
}
