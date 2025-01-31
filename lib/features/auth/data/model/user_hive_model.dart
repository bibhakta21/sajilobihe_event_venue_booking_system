import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sajilobihe_event_venue_booking_system/app/constants/hive_table_constant.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/domain/entity/user_entity.dart';
import 'package:uuid/uuid.dart';

part 'user_hive_model.g.dart';
// dart run build_runner build -d

@HiveType(typeId: HiveTableConstant.userTableId)
class UserHiveModel extends Equatable {
  @HiveField(0)
  final String? userId;

  @HiveField(1)
  final String fullName;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String password;

  @HiveField(4)
  final String phone;

  @HiveField(5)
  final String address;

  @HiveField(6)
  final String role;

  @HiveField(7)
  final String? avatar;

  UserHiveModel({
    String? userId,
    required this.fullName,
    required this.email,
    required this.password,
    required this.phone,
    required this.address,
    required this.role,
    this.avatar,
  }) : userId = userId ?? const Uuid().v4();

  /// Initial constructor
  const UserHiveModel.initial()
      : userId = '',
        fullName = '',
        email = '',
        password = '',
        phone = '',
        address = '',
        role = '',
        avatar = '';

  // Convert from entity
  factory UserHiveModel.fromEntity(UserEntity entity) {
    return UserHiveModel(
      userId: entity.userId,
      fullName: entity.fullName,
      email: entity.email,
      password: entity.password,
      phone: entity.phone,
      address: entity.address,
      role: entity.role,
      avatar: entity.avatar,
    );
  }

  // Convert to entity
  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      fullName: fullName,
      email: email,
      password: password,
      phone: phone,
      address: address,
      role: role,
      avatar: avatar,
    );
  }

  static List<UserHiveModel> fromEntityList(List<UserEntity> entityList) {
    return entityList
        .map((entity) => UserHiveModel.fromEntity(entity))
        .toList();
  }

  @override
  List<Object?> get props => [userId, email];
}
