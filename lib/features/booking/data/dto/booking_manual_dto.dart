class BookingDTO {
  final String id;
  final String userId;
  final String venueId;
  final DateTime bookingDate;
  final String status;

  // Extended fields from populated data:
  final String? userName;
  final String? userEmail;
  final String? userPhone;
  final String? venueName;
  final List<String>? venueImages;
  final double? venuePrice;
  final int? venueCapacity;

  BookingDTO({
    required this.id,
    required this.userId,
    required this.venueId,
    required this.bookingDate,
    required this.status,
    this.userName,
    this.userEmail,
    this.userPhone,
    this.venueName,
    this.venueImages,
    this.venuePrice,
    this.venueCapacity,
  });

  /// Factory constructor to create `BookingDTO` from JSON
  factory BookingDTO.fromJson(Map<String, dynamic> json) {
    return BookingDTO(
      id: json['id'] as String,
      userId: json['userId'] as String,
      venueId: json['venueId'] as String,
      bookingDate: DateTime.parse(json['bookingDate'] as String),
      status: json['status'] as String,
      userName: json['userName'] as String?,
      userEmail: json['userEmail'] as String?,
      userPhone: json['userPhone'] as String?,
      venueName: json['venueName'] as String?,
      venueImages: (json['venueImages'] as List<dynamic>?)
          ?.map((item) => item as String)
          .toList(),
      venuePrice: (json['venuePrice'] as num?)?.toDouble(),
      venueCapacity: json['venueCapacity'] as int?,
    );
  }

  /// Converts `BookingDTO` to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'venueId': venueId,
      'bookingDate': bookingDate.toIso8601String(),
      'status': status,
      'userName': userName,
      'userEmail': userEmail,
      'userPhone': userPhone,
      'venueName': venueName,
      'venueImages': venueImages,
      'venuePrice': venuePrice,
      'venueCapacity': venueCapacity,
    };
  }
}
