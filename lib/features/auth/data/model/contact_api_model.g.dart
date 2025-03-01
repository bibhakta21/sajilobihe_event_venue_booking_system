// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactApiModel _$ContactApiModelFromJson(Map<String, dynamic> json) =>
    ContactApiModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      message: json['message'] as String,
    );

Map<String, dynamic> _$ContactApiModelToJson(ContactApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'message': instance.message,
    };
