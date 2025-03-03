class ContactDTO {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String message;

  ContactDTO({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.message,
  });

  /// Factory constructor to create `ContactDTO` from JSON
  factory ContactDTO.fromJson(Map<String, dynamic> json) {
    return ContactDTO(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      message: json['message'] as String,
    );
  }

  /// Converts `ContactDTO` to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'message': message,
    };
  }
}
