import 'package:sajilobihe_event_venue_booking_system/features/contact_us/domain/entity/contact_entity.dart';



abstract class ContactEvent {}

class SubmitContactEvent extends ContactEvent {
  final ContactEntity contact;
  SubmitContactEvent(this.contact);
}
