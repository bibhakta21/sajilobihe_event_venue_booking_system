

import 'package:sajilobihe_event_venue_booking_system/features/contact_us/domain/entity/contact_entity.dart';

abstract class ContactRepository {
  Future<bool> submitContact(ContactEntity contact);
  Future<List<ContactEntity>> getAllContacts();
  Future<bool> deleteContact(String id);
}
