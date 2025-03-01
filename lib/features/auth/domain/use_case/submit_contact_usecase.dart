import '../entity/contact_entity.dart';
import '../repository/contact_repository.dart';

class SubmitContactUseCase {
  final ContactRepository repository;

  SubmitContactUseCase(this.repository);

  Future<bool> call(ContactEntity contact) async {
    return await repository.submitContact(contact);
  }
}
