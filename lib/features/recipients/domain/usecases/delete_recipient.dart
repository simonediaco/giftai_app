// lib/features/recipients/domain/usecases/delete_recipient.dart
import '../repositories/recipients_repository.dart';

class DeleteRecipient {
  final RecipientsRepository _repository;
  
  DeleteRecipient(this._repository);
  
  Future<void> call(int id) {
    return _repository.deleteRecipient(id);
  }
}