// lib/features/recipients/domain/usecases/get_recipients.dart
import '../entities/recipient.dart';
import '../repositories/recipients_repository.dart';

class GetRecipients {
  final RecipientsRepository _repository;
  
  GetRecipients(this._repository);
  
  Future<List<Recipient>> call() {
    return _repository.getRecipients();
  }
}