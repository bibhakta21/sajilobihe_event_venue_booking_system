import 'package:sajilobihe_event_venue_booking_system/features/auth/domain/entity/contact_entity.dart';



abstract class ContactEvent {}

class SubmitContactEvent extends ContactEvent {
  final ContactEntity contact;
  SubmitContactEvent(this.contact);
}
