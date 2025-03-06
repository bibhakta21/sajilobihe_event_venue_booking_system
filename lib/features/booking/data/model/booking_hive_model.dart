import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sajilobihe_event_venue_booking_system/app/constants/hive_table_constant.dart';
import 'package:sajilobihe_event_venue_booking_system/features/booking/domain/entity/booking_entity.dart';
import 'package:uuid/uuid.dart';

part 'booking_hive_model.g.dart'; // For Hive's generated adapter

@HiveType(typeId: HiveTableConstant.bookingTableId)
class BookingHiveModel extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String venueId;

  @HiveField(3)
  final DateTime bookingDate;

  @HiveField(4)
  final String status;

  @HiveField(5)
  final String? userName;

  @HiveField(6)
  final String? userEmail;

  @HiveField(7)
  final String? userPhone;

  @HiveField(8)
  final String? venueName;

  @HiveField(9)
  final List<String>? venueImages;

  @HiveField(10)
  final double? venuePrice;

  @HiveField(11)
  final int? venueCapacity;

  BookingHiveModel({
    String? id,
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
  }) : id = id ?? const Uuid().v4();

  /// Convert from entity
  factory BookingHiveModel.fromEntity(BookingEntity entity) {
    return BookingHiveModel(
      id: entity.id,
      userId: entity.userId,
      venueId: entity.venueId,
      bookingDate: entity.bookingDate,
      status: entity.status,
      userName: entity.userName,
      userEmail: entity.userEmail,
      userPhone: entity.userPhone,
      venueName: entity.venueName,
      venueImages: entity.venueImages,
      venuePrice: entity.venuePrice,
      venueCapacity: entity.venueCapacity,
    );
  }

  /// Convert to entity
  BookingEntity toEntity() {
    return BookingEntity(
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
  }

  @override
  List<Object?> get props => [id, userId, venueId, bookingDate, status];
}
