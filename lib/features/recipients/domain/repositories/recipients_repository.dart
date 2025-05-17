// lib/features/recipients/domain/repositories/recipients_repository.dart
import '../entities/recipient.dart';

abstract class RecipientsRepository {
  Future<List<Recipient>> getRecipients();
  Future<Recipient> getRecipient(int id);
  Future<Recipient> createRecipient(Recipient recipient);
  Future<Recipient> updateRecipient(Recipient recipient);
  Future<void> deleteRecipient(int id);
}