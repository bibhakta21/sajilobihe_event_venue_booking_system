import 'package:equatable/equatable.dart';
import 'package:sajilobihe_event_venue_booking_system/features/contact_us/domain/entity/contact_entity.dart';


abstract class ContactState extends Equatable {
  const ContactState();

  @override
  List<Object?> get props => [];
}

class ContactInitial extends ContactState {}

class ContactLoading extends ContactState {}

class ContactsLoaded extends ContactState {
  final List<ContactEntity> contacts;
  const ContactsLoaded(this.contacts);

  @override
  List<Object?> get props => [contacts];
}

class ContactOperationSuccess extends ContactState {
  final String message;
  const ContactOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ContactError extends ContactState {
  final String error;
  const ContactError(this.error);

  @override
  List<Object?> get props => [error];
}
