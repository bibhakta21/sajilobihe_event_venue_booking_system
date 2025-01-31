import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/domain/entity/user_entity.dart';

@JsonSerializable()
class UserApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? userId;
  @JsonKey(name: 'name')
  final String fullName;
  final String email;
  final String password;
  final String phone;
  final String address;
  final String role;
  final String? avatar;

  const UserApiModel({
    this.userId,
    required this.fullName,
    required this.email,
    required this.password,
    required this.phone,
    required this.address,
    required this.role,
    this.avatar,
  });

  const UserApiModel.empty()
      : userId = '',
        fullName = '',
        email = '',
        password = '',
        phone = '',
        address = '',
        role = '',
        avatar = '';

  // From JSON
  factory UserApiModel.fromJson(Map<String, dynamic> json) {
    return UserApiModel(
      userId: json['_id'],
      fullName: json['name'],
      email: json['email'],
      password: json['password'],
      phone: json['phone'],
      address: json['address'],
      role: json['role'],
      avatar: json['avatar'],
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'name': fullName,
      'email': email,
      'password': password,
      'phone': phone,
      'address': address,
      'role': role,
      'avatar': avatar,
    };
  }

  // Convert API Object to Entity
  UserEntity toEntity() => UserEntity(
        userId: userId,
        fullName: fullName,
        email: email,
        password: password,
        phone: phone,
        address: address,
        role: role,
        avatar: avatar,
      );

  // Convert Entity to API Object
  static UserApiModel fromEntity(UserEntity entity) => UserApiModel(
        fullName: entity.fullName,
        email: entity.email,
        password: entity.password,
        phone: entity.phone,
        address: entity.address,
        role: entity.role,
        avatar: entity.avatar,
      );

  // Convert API List to Entity List
  static List<UserEntity> toEntityList(List<UserApiModel> models) =>
      models.map((model) => model.toEntity()).toList();

  @override
  List<Object?> get props => [
        userId,
        fullName,
        email,
        password,
        phone,
        address,
        role,
        avatar,
      ];
}
