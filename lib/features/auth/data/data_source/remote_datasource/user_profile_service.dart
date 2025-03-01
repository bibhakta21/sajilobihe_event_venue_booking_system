// user_profile_service.dart
import 'package:dio/dio.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/data/model/user_profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UserProfileService {
  final Dio dio;

  UserProfileService(this.dio);

  Future<UserProfile> fetchUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception("No token found");
    }

    final response = await dio.get(
      "http://10.0.2.2:3000/api/users/me",
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200) {
      return UserProfile.fromJson(response.data);
    } else {
      throw Exception("Failed to load profile");
    }
  }

  Future<UserProfile> updateUserProfile({
    required String username,
    required String email,
    required String phone,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) throw Exception("No token found");

    final response = await dio.put(
      "http://10.0.2.2:3000/api/users/me",
      data: {
        "username": username,
        "email": email,
        "phone": phone,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      ),
    );

    if (response.statusCode == 200) {
      return UserProfile.fromJson(response.data);
    } else {
      throw Exception("Failed to update profile");
    }
  }
}
