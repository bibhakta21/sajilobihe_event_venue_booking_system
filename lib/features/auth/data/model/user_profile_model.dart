// user_profile_model.dart
class UserProfile {
  final String username;
  final String email;
  final String phone;
  final String address;
  final String avatar;
  final String role;

  UserProfile({
    required this.username,
    required this.email,
    required this.phone,
    required this.address,
    required this.avatar,
    required this.role,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      avatar: json['avatar'] ?? '',
      role: json['role'] ?? '',
    );
  }
}
