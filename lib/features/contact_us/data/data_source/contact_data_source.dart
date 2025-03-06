import 'package:sajilobihe_event_venue_booking_system/features/contact_us/domain/entity/contact_entity.dart';

abstract class IContactDataSource {
  Future<void> submitContact(ContactEntity contactEntity);
  Future<List<ContactEntity>> getAllContacts();
  Future<void> deleteContact(String id);
}
