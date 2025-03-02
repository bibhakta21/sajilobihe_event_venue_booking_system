import 'package:dio/dio.dart';
import 'package:sajilobihe_event_venue_booking_system/app/constants/api_endpoints.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/data/model/venue_model.dart';

/// Abstract contract for venue-related API calls.
abstract class VenueRemoteDataSource {
  Future<List<VenueModel>> getAllVenues();
  Future<VenueModel> getVenueById(String id);
  Future<VenueModel> addVenue(Map<String, dynamic> venueData);
  Future<VenueModel> updateVenue(String id, Map<String, dynamic> venueData);
  Future<void> deleteVenue(String id);
}

/// Implementation that uses Dio to perform HTTP requests.
class VenueRemoteDataSourceImpl implements VenueRemoteDataSource {
  final Dio dio;

  VenueRemoteDataSourceImpl(this.dio);

  @override
  Future<List<VenueModel>> getAllVenues() async {
    final response = await dio.get(ApiEndpoints.getAllVenues);
    if (response.statusCode == 200) {
      List data = response.data;
      return data.map((e) => VenueModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load venues");
    }
  }

  @override
  Future<VenueModel> getVenueById(String id) async {
    final response = await dio.get("${ApiEndpoints.venues}/$id");
    if (response.statusCode == 200) {
      return VenueModel.fromJson(response.data);
    } else {
      throw Exception("Failed to load venue");
    }
  }

  @override
  Future<VenueModel> addVenue(Map<String, dynamic> venueData) async {
    // If venueData contains images, extract them as file paths.
    List<String>? imagePaths;
    if (venueData.containsKey('images') && venueData['images'] is List) {
      imagePaths = List<String>.from(venueData['images']);
      // Remove images from venueData; we'll add them separately.
      venueData.remove('images');
    }

    // Create FormData from the remaining venue data.
    FormData formData = FormData.fromMap(venueData);

    // If image paths were provided, add each as a MultipartFile.
    if (imagePaths != null && imagePaths.isNotEmpty) {
      formData.files.addAll(
        await Future.wait(imagePaths.map((path) async {
          return MapEntry(
            'images', // Field name should match backend expectation.
            await MultipartFile.fromFile(path, filename: path.split('/').last),
          );
        })),
      );
    }

    final response = await dio.post(ApiEndpoints.venues, data: formData);
    if (response.statusCode == 201) {
      // Adjust parsing as needed based on your backend's response.
      return VenueModel.fromJson(response.data['venue']);
    } else {
      throw Exception("Failed to add venue");
    }
  }

  @override
  Future<VenueModel> updateVenue(String id, Map<String, dynamic> venueData) async {
    final response = await dio.put("${ApiEndpoints.venues}/$id", data: venueData);
    if (response.statusCode == 200) {
      // Adjust based on your response (e.g., response.data['updatedVenue'])
      return VenueModel.fromJson(response.data['updatedVenue']);
    } else {
      throw Exception("Failed to update venue");
    }
  }

  @override
  Future<void> deleteVenue(String id) async {
    final response = await dio.delete("${ApiEndpoints.venues}/$id");
    if (response.statusCode != 200) {
      throw Exception("Failed to delete venue");
    }
  }
}
