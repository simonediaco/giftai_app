// lib/features/recipients/domain/usecases/get_recipient.dart
import '../entities/recipient.dart';
import '../repositories/recipients_repository.dart';

class GetRecipient {
  final RecipientsRepository _repository;
  
  GetRecipient(this._repository);
  
  Future<Recipient> call(int id) {
    return _repository.getRecipient(id);
  }
}