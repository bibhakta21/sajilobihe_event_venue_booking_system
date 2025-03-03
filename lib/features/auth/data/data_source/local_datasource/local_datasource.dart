import 'dart:io';

import 'package:sajilobihe_event_venue_booking_system/core/network/hive_service.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/data/data_source/user_data_source.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/data/model/user_hive_model.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/domain/entity/user_entity.dart';

class UserLocalDataSource implements IUserDataSource {
  final HiveService _hiveService;

  UserLocalDataSource(this._hiveService);

  @override
  Future<void> createUser(UserEntity userEntity) async {
    try {
      // Convert UserEntity to UserHiveModel
      final userHiveModel = UserHiveModel.fromEntity(userEntity);
      await _hiveService.addUser(userHiveModel);
    } catch (e) {
      throw Exception(e);
    }
  }
    
  @override
  Future<String> loginUser(String email, String password)async {
    try {
      await _hiveService.login(email,password);
      return Future.value("Success");
    } catch (e) {
      return Future.error(e);
      
    }
  }

  @override
  Future<void> deleteUser(String id) async {
    try {
      return await _hiveService.deleteUser(id);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<UserEntity>> getAllUsers() {
    try {
      return _hiveService.getAllUsers().then((value) {
        return value.map((e) => e.toEntity()).toList();
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<String> uploadProfilePicture(File file) {
    // TODO: implement uploadProfilePicture
    throw UnimplementedError();
  }
  
  @override
  Future<UserEntity> getProfile(String token) {
    // TODO: implement getProfile
    throw UnimplementedError();
  }
}
