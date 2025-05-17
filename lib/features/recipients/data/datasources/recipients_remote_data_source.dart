// lib/features/recipients/data/datasources/recipients_remote_data_source.dart
import '../../../../core/api/api_client.dart';
import '../../../../core/errors/api_error.dart';
import '../models/recipient_model.dart';

abstract class RecipientsRemoteDataSource {
  Future<List<RecipientModel>> getRecipients();
  Future<RecipientModel> getRecipient(int id);
  Future<RecipientModel> createRecipient(Map<String, dynamic> data);
  Future<RecipientModel> updateRecipient(int id, Map<String, dynamic> data);
  Future<void> deleteRecipient(int id);
}

class RecipientsRemoteDataSourceImpl implements RecipientsRemoteDataSource {
  final ApiClient _apiClient;
  
  RecipientsRemoteDataSourceImpl(this._apiClient);
  
  @override
  Future<List<RecipientModel>> getRecipients() async {
    try {
      final response = await _apiClient.get('/api/recipients/');
      return (response.data as List)
          .map((json) => RecipientModel.fromJson(json))
          .toList();
    } catch (e) {
      throw ApiError(
        message: 'Errore nel recupero dei destinatari',
        statusCode: 500,
      );
    }
  }
  
  @override
  Future<RecipientModel> getRecipient(int id) async {
    try {
      final response = await _apiClient.get('/api/recipients/$id/');
      return RecipientModel.fromJson(response.data);
    } catch (e) {
      throw ApiError(
        message: 'Errore nel recupero del destinatario',
        statusCode: 500,
      );
    }
  }
  
  @override
  Future<RecipientModel> createRecipient(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.post(
        '/api/recipients/',
        data: data,
      );
      return RecipientModel.fromJson(response.data);
    } catch (e) {
      throw ApiError(
        message: 'Errore nella creazione del destinatario',
        statusCode: 500,
      );
    }
  }
  
  @override
  Future<RecipientModel> updateRecipient(int id, Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.put(
        '/api/recipients/$id/',
        data: data,
      );
      return RecipientModel.fromJson(response.data);
    } catch (e) {
      throw ApiError(
        message: 'Errore nell\'aggiornamento del destinatario',
        statusCode: 500,
      );
    }
  }
  
  @override
  Future<void> deleteRecipient(int id) async {
    try {
      await _apiClient.delete('/api/recipients/$id/');
    } catch (e) {
      throw ApiError(
        message: 'Errore nell\'eliminazione del destinatario',
        statusCode: 500,
      );
    }
  }
}