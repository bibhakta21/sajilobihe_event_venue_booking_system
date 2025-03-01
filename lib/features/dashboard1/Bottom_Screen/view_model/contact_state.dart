abstract class ContactState {}

class ContactInitialState extends ContactState {}

class ContactLoadingState extends ContactState {}

class ContactSuccessState extends ContactState {}

class ContactErrorState extends ContactState {
  final String message;
  ContactErrorState(this.message);
}
