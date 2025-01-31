import 'package:equatable/equatable.dart';

class UserEntity extends Equatable{
  final String? userId;
  final String fullName;
  final String email;
  final String password;
  final String phone;
  final String address;
  final String role;
  final String? avatar;

  const UserEntity({
    this.userId,
    required this.fullName,
    required this.email,
    required this.password,
    required this.phone,
    required this.address,
    required this.role,
    this.avatar,
  });

  @override
  List<Object?> get props => [
    userId,
    email,
  ];
}