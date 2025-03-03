import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:sajilobihe_event_venue_booking_system/core/error/failure.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/data/data_source/local_datasource/local_datasource.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/domain/entity/user_entity.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/domain/repository/user_repository.dart';

class UserLocalRepository implements IUserRepository {
  final UserLocalDataSource _userLocalDataSource;

  UserLocalRepository({required UserLocalDataSource userLocalDataSource})
      : _userLocalDataSource = userLocalDataSource;

  @override
  Future<Either<Failure, void>> createUser(UserEntity userEntity) {
    try {
      _userLocalDataSource.createUser(userEntity);
      return Future.value(const Right(null));
    } catch (e) {
      return Future.value(Left(LocalDatabaseFailure(message: e.toString())));
    }
  }

  @override
  Future<Either<Failure, String>> loginUser(
    String email,
    String password,
  ) async {
    try {
      final token = await _userLocalDataSource.loginUser(email, password);
      return Right(token);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(String id) async {
    try {
      await _userLocalDataSource.deleteUser(id);
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: 'Error deleting User: $e'));
    }
  }

  @override
  Future<Either<Failure, List<UserEntity>>> getAllUsers() async {
    try {
      final users = await _userLocalDataSource.getAllUsers();
      return Right(users);
    } catch (e) {
      return Left(
        LocalDatabaseFailure(message: 'Error getting all users: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePicture(File file) {
    // TODO: implement uploadProfilePicture
    throw UnimplementedError();
  }

  getProfile(String token) {
    // TODO: implement getProfile
    throw UnimplementedError();
  }
}
