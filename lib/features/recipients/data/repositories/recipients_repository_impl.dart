import '../../domain/entities/recipient.dart';
import '../../domain/repositories/recipients_repository.dart';
import '../datasources/recipients_remote_data_source.dart';
import '../models/recipient_model.dart';

class RecipientsRepositoryImpl implements RecipientsRepository {
  final RecipientsRemoteDataSource _remoteDataSource;
  
  RecipientsRepositoryImpl(this._remoteDataSource);
  
  @override
  Future<List<Recipient>> getRecipients() async {
    return await _remoteDataSource.getRecipients();
  }
  
  @override
  Future<Recipient> getRecipient(int id) async {
    return await _remoteDataSource.getRecipient(id);
  }
  
  @override
  Future<Recipient> createRecipient(Recipient recipient) async {
    // Converti direttamente l'entità in un modello
    final recipientModel = RecipientModel(
      id: recipient.id,
      name: recipient.name,
      gender: recipient.gender,
      birthDate: recipient.birthDate,
      relation: recipient.relation,
      interests: recipient.interests,
      notes: recipient.notes,
    );
    
    // Invia il modello convertito in JSON
    return await _remoteDataSource.createRecipient(recipientModel.toJson());
  }
  
  @override
  Future<Recipient> updateRecipient(Recipient recipient) async {
    // Converti direttamente l'entità in un modello
    final recipientModel = RecipientModel(
      id: recipient.id,
      name: recipient.name,
      gender: recipient.gender,
      birthDate: recipient.birthDate,
      relation: recipient.relation,
      interests: recipient.interests,
      notes: recipient.notes,
    );
    
    // Invia il modello convertito in JSON
    return await _remoteDataSource.updateRecipient(
      recipient.id,
      recipientModel.toJson(),
    );
  }
  
  @override
  Future<void> deleteRecipient(int id) async {
    await _remoteDataSource.deleteRecipient(id);
  }
}