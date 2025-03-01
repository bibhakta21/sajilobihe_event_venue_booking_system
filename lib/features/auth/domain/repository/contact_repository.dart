

import 'package:sajilobihe_event_venue_booking_system/features/auth/domain/entity/contact_entity.dart';

abstract class ContactRepository {
  Future<bool> submitContact(ContactEntity contact);
  Future<List<ContactEntity>> getAllContacts();
  Future<bool> deleteContact(String id);
}
