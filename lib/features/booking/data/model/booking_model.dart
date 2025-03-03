import 'package:sajilobihe_event_venue_booking_system/features/booking/domain/entity/booking_entity.dart';



class BookingModel extends BookingEntity {
  BookingModel({
    required String id,
    required String userId,
    required String venueId,
    required DateTime bookingDate,
    required String status,
    String? userName,
    String? userEmail,
    String? userPhone,
    String? venueName,
    List<String>? venueImages,
    double? venuePrice,
    int? venueCapacity,
  }) : super(
          id: id,
          userId: userId,
          venueId: venueId,
          bookingDate: bookingDate,
          status: status,
          userName: userName,
          userEmail: userEmail,
          userPhone: userPhone,
          venueName: venueName,
          venueImages: venueImages,
          venuePrice: venuePrice,
          venueCapacity: venueCapacity,
        );

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    // Parse user details (populated)
    String userId = '';
    String userName = '';
    String userEmail = '';
    String userPhone = '';
    final userField = json['user'];
    if (userField != null) {
      if (userField is Map<String, dynamic>) {
        userId = userField['_id'] ?? '';
        userName = userField['username'] ?? '';
        userEmail = userField['email'] ?? '';
        userPhone = userField['phone'] ?? '';
      } else if (userField is String) {
        userId = userField;
      }
    }

    // Parse venue details (populated)
    String venueId = '';
    String venueName = '';
    List<String> venueImages = [];
    double? venuePrice;
    int? venueCapacity;
    final venueField = json['venue'];
    if (venueField != null) {
      if (venueField is Map<String, dynamic>) {
        venueId = venueField['_id'] ?? '';
        venueName = venueField['name'] ?? '';
        // NEW: Parse price and capacity
        if (venueField['price'] != null) {
          venuePrice = (venueField['price'] as num).toDouble();
        }
        if (venueField['capacity'] != null) {
          venueCapacity = (venueField['capacity'] as num).toInt();
        }
        if (venueField['images'] is List) {
          venueImages = (venueField['images'] as List)
              .map((e) => e.toString())
              .toList();
        }
      } else if (venueField is String) {
        venueId = venueField;
      }
    }

    // Parse bookingDate safely
    String rawDate = json['bookingDate'] ?? DateTime.now().toIso8601String();
    DateTime bookingDate;
    try {
      bookingDate = DateTime.parse(rawDate);
    } catch (_) {
      bookingDate = DateTime.now();
    }

    return BookingModel(
      id: json['_id'] ?? '',
      userId: userId,
      venueId: venueId,
      bookingDate: bookingDate,
      status: json['status'] ?? 'pending',
      userName: userName,
      userEmail: userEmail,
      userPhone: userPhone,
      venueName: venueName,
      venueImages: venueImages,
      venuePrice: venuePrice,
      venueCapacity: venueCapacity,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': userId,
      'venue': venueId,
      'bookingDate': bookingDate.toIso8601String(),
      'status': status,
    };
  }
}
