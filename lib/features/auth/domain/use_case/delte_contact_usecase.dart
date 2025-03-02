import '../repository/contact_repository.dart';

class DeleteContactUseCase {
  final ContactRepository repository;
  DeleteContactUseCase(this.repository);

  Future<bool> call(String id) async {
    return await repository.deleteContact(id);
  }
}
