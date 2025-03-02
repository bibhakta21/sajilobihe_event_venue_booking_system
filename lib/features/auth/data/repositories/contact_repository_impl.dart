import 'package:sajilobihe_event_venue_booking_system/features/auth/data/data_source/remote_datasource/contact_remote_datasource.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/data/model/contact_api_model.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/domain/entity/contact_entity.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/domain/repository/contact_repository.dart';

class ContactRepositoryImpl implements ContactRepository {
  final ContactRemoteDataSource remoteDataSource;
  ContactRepositoryImpl(this.remoteDataSource);

  @override
  Future<bool> submitContact(ContactEntity contact) async {
    // For submission, id can be empty as the server assigns one.
    final model = ContactApiModel(
      id: "",
      name: contact.name,
      email: contact.email,
      phone: contact.phone,
      message: contact.message,
    );
    return await remoteDataSource.submitContact(model);
  }

  @override
  Future<List<ContactEntity>> getAllContacts() async {
    final models = await remoteDataSource.getAllContacts();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<bool> deleteContact(String id) async {
    return await remoteDataSource.deleteContact(id);
  }
}
