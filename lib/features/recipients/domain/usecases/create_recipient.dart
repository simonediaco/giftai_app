// lib/features/recipients/domain/usecases/create_recipient.dart
import '../entities/recipient.dart';
import '../repositories/recipients_repository.dart';

class CreateRecipient {
  final RecipientsRepository _repository;
  
  CreateRecipient(this._repository);
  
  Future<Recipient> call(Recipient recipient) {
    return _repository.createRecipient(recipient);
  }
}