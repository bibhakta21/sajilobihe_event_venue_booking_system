import 'package:dio/dio.dart';
import 'package:sajilobihe_event_venue_booking_system/app/constants/api_endpoints.dart';
import 'package:sajilobihe_event_venue_booking_system/features/contact_us/data/model/contact_api_model.dart';


abstract class ContactRemoteDataSource {
  Future<bool> submitContact(ContactApiModel contact);
  Future<List<ContactApiModel>> getAllContacts();
  Future<bool> deleteContact(String id);
}

class ContactRemoteDataSourceImpl implements ContactRemoteDataSource {
  final Dio dio;
  ContactRemoteDataSourceImpl(this.dio);

  @override
  Future<bool> submitContact(ContactApiModel contact) async {
    try {
      final response = await dio.post(
        ApiEndpoints.submitContact,
        data: contact.toJson(),
      );
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception("Failed to submit contact request");
    }
  }

  @override
  Future<List<ContactApiModel>> getAllContacts() async {
    try {
      final response = await dio.get(ApiEndpoints.getAllContacts);
      if (response.statusCode == 200) {
        List data = response.data;
        return data.map((e) => ContactApiModel.fromJson(e)).toList();
      } else {
        throw Exception("Failed to get contacts");
      }
    } catch (e) {
      throw Exception("Failed to get contacts: ${e.toString()}");
    }
  }

  @override
  Future<bool> deleteContact(String id) async {
    try {
      final response = await dio.delete("${ApiEndpoints.deleteContact}/$id");
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception("Failed to delete contact: ${e.toString()}");
    }
  }
}
