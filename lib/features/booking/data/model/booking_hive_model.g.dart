// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookingHiveModelAdapter extends TypeAdapter<BookingHiveModel> {
  @override
  final int typeId = 1;

  @override
  BookingHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookingHiveModel(
      id: fields[0] as String?,
      userId: fields[1] as String,
      venueId: fields[2] as String,
      bookingDate: fields[3] as DateTime,
      status: fields[4] as String,
      userName: fields[5] as String?,
      userEmail: fields[6] as String?,
      userPhone: fields[7] as String?,
      venueName: fields[8] as String?,
      venueImages: (fields[9] as List?)?.cast<String>(),
      venuePrice: fields[10] as double?,
      venueCapacity: fields[11] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, BookingHiveModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.venueId)
      ..writeByte(3)
      ..write(obj.bookingDate)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.userName)
      ..writeByte(6)
      ..write(obj.userEmail)
      ..writeByte(7)
      ..write(obj.userPhone)
      ..writeByte(8)
      ..write(obj.venueName)
      ..writeByte(9)
      ..write(obj.venueImages)
      ..writeByte(10)
      ..write(obj.venuePrice)
      ..writeByte(11)
      ..write(obj.venueCapacity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
