import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/domain/use_case/submit_contact_usecase.dart';

import 'contact_event.dart';
import 'contact_state.dart';

class ContactBlocView extends Bloc<ContactEvent, ContactState> {
  final SubmitContactUseCase submitContactUseCase;

  ContactBlocView(this.submitContactUseCase) : super(ContactInitialState()) {
    on<SubmitContactEvent>((event, emit) async {
      emit(ContactLoadingState());
      try {
        final success = await submitContactUseCase(event.contact);
        if (success) {
          emit(ContactSuccessState());
        } else {
          emit(ContactErrorState("Failed to submit contact form"));
        }
      } catch (e) {
        emit(ContactErrorState("An error occurred"));
      }
    });
  }
}
