import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sajilobihe_event_venue_booking_system/app/constants/hive_table_constant.dart';
import 'package:sajilobihe_event_venue_booking_system/features/contact_us/domain/entity/contact_entity.dart';
import 'package:uuid/uuid.dart';

part 'contact_hive_model.g.dart'; // Hive-generated adapter

@HiveType(typeId: HiveTableConstant.contactTableId)
class ContactHiveModel extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String phone;

  @HiveField(4)
  final String message;

  ContactHiveModel({
    String? id,
    required this.name,
    required this.email,
    required this.phone,
    required this.message,
  }) : id = id ?? const Uuid().v4();

  /// Convert from entity
  factory ContactHiveModel.fromEntity(ContactEntity entity) {
    return ContactHiveModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      phone: entity.phone,
      message: entity.message,
    );
  }

  /// Convert to entity
  ContactEntity toEntity() {
    return ContactEntity(
      id: id,
      name: name,
      email: email,
      phone: phone,
      message: message,
    );
  }

  @override
  List<Object?> get props => [id, name, email, phone, message];
}
