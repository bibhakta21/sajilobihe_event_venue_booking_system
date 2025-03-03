import 'dart:io';

import 'package:dio/dio.dart';
import 'package:sajilobihe_event_venue_booking_system/app/constants/api_endpoints.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/data/data_source/user_data_source.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/data/model/user_api_model.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/domain/entity/user_entity.dart';

class UserRemoteDataSource implements IUserDataSource {
  final Dio _dio;
  UserRemoteDataSource(this._dio);

  @override
  Future<void> createUser(UserEntity userEntity) async {
    try {
      // Convert entity to model
      var userApiModel = UserApiModel.fromEntity(userEntity);
      var response = await _dio.post(
        ApiEndpoints.register,
        data: userApiModel.toJson(),
      );
      if (response.statusCode == 201) {
        return;
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> deleteUser(String id) {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

  // @override
  // Future<List<UserEntity>> getAllUsers() async {
  //   try {
  //     var response = await _dio.get(ApiEndpoints.getAllUsers);
  //     if (response.statusCode == 200) {
  //       GetAllUserDTO userAddDTO = GetAllUserDTO.fromJson(response.data);
  //       return UserApiModel.toEntityList(userAddDTO.data);
  //     } else {
  //       throw Exception(response.statusMessage);
  //     }
  //   } on DioException catch (e) {
  //     throw Exception(e);
  //   } catch (e) {
  //     throw Exception(e);
  //   }
  // }

  @override
  Future<String> loginUser(String email, String password) async {
    try {
      Response response = await _dio.post(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );
      if (response.statusCode == 200) {
        final token = response.data['token'] as String;
        return token;
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<String> uploadProfilePicture(File file) async {
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
      });

      Response response = await _dio.post(
        ApiEndpoints.uploadImage,
        data: formData,
        options: Options(
          contentType:
              'multipart/form-data', // <-- Specify multipart/form-data here
        ),
      );

      if (response.statusCode == 200) {
        return response.data['data'];
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e);
    } catch (e) {
      throw Exception(e);
    }
  }

  // New method: Get current user profile using the token.
  @override
  Future<UserEntity> getProfile(String token) async {
    try {
      Response response = await _dio.get(
        ApiEndpoints.profile,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        // Convert response JSON to UserApiModel and then to UserEntity.
        UserApiModel userApiModel = UserApiModel.fromJson(response.data);
        return userApiModel.toEntity();
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<UserEntity>> getAllUsers() {
    // TODO: implement getAllUsers
    throw UnimplementedError();
  }
}
