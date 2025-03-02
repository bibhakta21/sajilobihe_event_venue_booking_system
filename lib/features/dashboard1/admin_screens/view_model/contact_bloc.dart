import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/domain/use_case/delte_contact_usecase.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/domain/use_case/get_all_contact_usecase.dart';
import 'contact_event.dart';
import 'contact_state.dart';


class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final GetAllContactsUseCase getAllContactsUseCase;
  final DeleteContactUseCase deleteContactUseCase;

  ContactBloc({
    required this.getAllContactsUseCase,
    required this.deleteContactUseCase,
  }) : super(ContactInitial()) {
    on<LoadContacts>(_onLoadContacts);
    on<DeleteContactEvent>(_onDeleteContact);
  }

  Future<void> _onLoadContacts(
      LoadContacts event, Emitter<ContactState> emit) async {
    emit(ContactLoading());
    try {
      final contacts = await getAllContactsUseCase();
      emit(ContactsLoaded(contacts));
    } catch (e) {
      emit(ContactError(e.toString()));
    }
  }

  Future<void> _onDeleteContact(
      DeleteContactEvent event, Emitter<ContactState> emit) async {
    emit(ContactLoading());
    try {
      final success = await deleteContactUseCase(event.id);
      if (success) {
        emit(ContactOperationSuccess("Contact deleted successfully"));
        add(LoadContacts()); // Reload contacts after deletion
      } else {
        emit(ContactError("Failed to delete contact"));
      }
    } catch (e) {
      emit(ContactError(e.toString()));
    }
  }
}
