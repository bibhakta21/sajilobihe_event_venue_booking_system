import 'package:dio/dio.dart';
import 'package:sajilobihe_event_venue_booking_system/app/constants/api_endpoints.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/data/model/venue_api_model.dart';

class VenueRemoteDataSource {
  final Dio dio;

  VenueRemoteDataSource(this.dio);

  Future<List<VenueApiModel>> fetchVenues() async {
    try {
      final response =
          await dio.get('${ApiEndpoints.baseUrl}${ApiEndpoints.getAllVenue}');

      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => VenueApiModel.fromJson(json))
            .toList();
      } else {
        throw Exception("Failed to load venues");
      }
    } catch (e) {
      throw Exception("Error fetching venues: $e");
    }
  }
}
