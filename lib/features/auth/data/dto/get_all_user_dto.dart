import 'package:json_annotation/json_annotation.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/data/model/user_api_model.dart';

part 'get_all_user_dto.g.dart';
// dart run build_runner build -d

@JsonSerializable()
class GetAllUserDTO {
  final bool success;
  final int count;
  final List<UserApiModel> data;

  GetAllUserDTO({
    required this.success,
    required this.count,
    required this.data,
  });

  Map<String, dynamic> toJson() => _$GetAllUserDTOToJson(this);


  factory GetAllUserDTO.fromJson(Map<String, dynamic> json) =>
  _$GetAllUserDTOFromJson(json);
}