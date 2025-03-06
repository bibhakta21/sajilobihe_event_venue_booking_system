import 'package:sajilobihe_event_venue_booking_system/core/network/hive_service.dart';
import 'package:sajilobihe_event_venue_booking_system/features/contact_us/data/data_source/contact_data_source.dart';
import 'package:sajilobihe_event_venue_booking_system/features/contact_us/data/model/contact_hive_model.dart';
import 'package:sajilobihe_event_venue_booking_system/features/contact_us/domain/entity/contact_entity.dart';

class ContactLocalDataSource implements IContactDataSource {
  final HiveService _hiveService;

  ContactLocalDataSource(this._hiveService);

  @override
  Future<void> submitContact(ContactEntity contactEntity) async {
    try {
      final contactModel = ContactHiveModel.fromEntity(contactEntity);
      await _hiveService.addContact(contactModel);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<ContactEntity>> getAllContacts() async {
    try {
      final contacts = await _hiveService.getAllContacts();
      return contacts.map((e) => e.toEntity()).toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> deleteContact(String id) async {
    try {
      await _hiveService.deleteContact(id);
    } catch (e) {
      throw Exception(e);
    }
  }
}
