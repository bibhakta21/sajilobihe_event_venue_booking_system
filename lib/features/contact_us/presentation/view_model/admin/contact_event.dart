import 'package:equatable/equatable.dart';

abstract class ContactEvent extends Equatable {
  const ContactEvent();

  @override
  List<Object?> get props => [];
}

class LoadContacts extends ContactEvent {}

class DeleteContactEvent extends ContactEvent {
  final String id;
  const DeleteContactEvent(this.id);
  
  @override
  List<Object?> get props => [id];
}
