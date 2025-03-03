// UserDTO (Manual JSON Serialization)
class UserDTO {
  final String? userId;
  final String fullName;
  final String email;
  final String password;
  final String phone;
  final String address;
  final String role;
  final String? avatar;

  const UserDTO({
    this.userId,
    required this.fullName,
    required this.email,
    required this.password,
    required this.phone,
    required this.address,
    required this.role,
    this.avatar,
  });

  /// Factory method to create `UserDTO` from JSON
  factory UserDTO.fromJson(Map<String, dynamic> json) {
    return UserDTO(
      userId: json['userId'] as String?,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      role: json['role'] as String,
      avatar: json['avatar'] as String?,
    );
  }

  /// Converts `UserDTO` to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'fullName': fullName,
      'email': email,
      'password': password,
      'phone': phone,
      'address': address,
      'role': role,
      'avatar': avatar,
    };
  }
}
