class BookingEntity {
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
  final double? venuePrice;    // NEW: Venue price
  final int? venueCapacity;    // NEW: Venue capacity

  BookingEntity({
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
}
