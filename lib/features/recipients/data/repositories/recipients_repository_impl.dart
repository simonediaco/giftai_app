
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/recipient.dart';
import '../../domain/repositories/recipients_repository.dart';
import '../datasources/recipients_remote_data_source.dart';
import '../models/recipient_model.dart';

class RecipientsRepositoryImpl implements RecipientsRepository {
  final RecipientsRemoteDataSource _remoteDataSource;
  static const String key = 'recipients';

  RecipientsRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Recipient>> getRecipients() async {
    try {
      // Prendi i dati dal backend
      final recipients = await _remoteDataSource.getRecipients();
      print('Recipients from API: $recipients');
      
      // Salva in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final recipientsJson = recipients.map((r) => r.toJson()).toList();
      await prefs.setString(key, jsonEncode(recipientsJson));
      
      print('Saved recipients: ${recipients.length}');
      return recipients;
    } catch (e) {
      print('Error getting recipients: $e');
      // Recupera da SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final String? storedData = prefs.getString(key);
      if (storedData != null) {
        final List<dynamic> json = jsonDecode(storedData);
        return json.map((item) => RecipientModel.fromJson(item)).toList();
      }
      return [];
    }
  }

  @override
  Future<Recipient> getRecipient(int id) async {
    return await _remoteDataSource.getRecipient(id);
  }

  @override
  Future<Recipient> createRecipient(Recipient recipient) async {
    final recipientModel = RecipientModel(
      id: recipient.id,
      name: recipient.name,
      gender: recipient.gender,
      birthDate: recipient.birthDate,
      relation: recipient.relation,
      interests: recipient.interests,
      notes: recipient.notes,
    );
    return await _remoteDataSource.createRecipient(recipientModel.toJson());
  }

  @override
  Future<Recipient> updateRecipient(Recipient recipient) async {
    final recipientModel = RecipientModel(
      id: recipient.id,
      name: recipient.name,
      gender: recipient.gender,
      birthDate: recipient.birthDate,
      relation: recipient.relation,
      interests: recipient.interests,
      notes: recipient.notes,
    );
    return await _remoteDataSource.updateRecipient(recipient.id, recipientModel.toJson());
  }

  @override
  Future<void> deleteRecipient(int id) async {
    await _remoteDataSource.deleteRecipient(id);
  }
}
