// lib/features/recipients/domain/usecases/update_recipient.dart
import '../entities/recipient.dart';
import '../repositories/recipients_repository.dart';

class UpdateRecipient {
  final RecipientsRepository _repository;
  
  UpdateRecipient(this._repository);
  
  Future<Recipient> call(Recipient recipient) {
    return _repository.updateRecipient(recipient);
  }
}