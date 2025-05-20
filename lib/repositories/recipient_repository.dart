import 'package:giftai/config/app_config.dart';
import 'package:giftai/models/recipient_model.dart';
import 'package:giftai/services/api_client.dart';

class RecipientRepository {
  final ApiClient _apiClient;

  RecipientRepository(this._apiClient);

  // Ottieni lista destinatari
  Future<List<RecipientModel>> getRecipients() async {
    try {
      final response = await _apiClient.get(AppConfig.recipientsEndpoint);
      
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => RecipientModel.fromJson(json))
            .toList();
      }
      
      return [];
    } catch (e) {
      return [];
    }
  }

  // Ottieni dettagli destinatario
  Future<RecipientModel?> getRecipient(int id) async {
    try {
      final response = await _apiClient.get('${AppConfig.recipientsEndpoint}$id/');
      
      if (response.statusCode == 200) {
        return RecipientModel.fromJson(response.data);
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  // Crea nuovo destinatario
  Future<RecipientModel?> createRecipient(RecipientModel recipient) async {
    try {
      final response = await _apiClient.post(
        AppConfig.recipientsEndpoint,
        data: recipient.toJson(),
      );
      
      if (response.statusCode == 201) {
        return RecipientModel.fromJson(response.data);
      }
      
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Aggiorna destinatario
  Future<RecipientModel?> updateRecipient(RecipientModel recipient) async {
    try {
      if (recipient.id == null) {
        throw Exception('Cannot update recipient without ID');
      }
      
      final response = await _apiClient.patch(
        '${AppConfig.recipientsEndpoint}${recipient.id}/',
        data: recipient.toJson(),
      );
      
      if (response.statusCode == 200) {
        return RecipientModel.fromJson(response.data);
      }
      
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Elimina destinatario
  Future<bool> deleteRecipient(int id) async {
    try {
      final response = await _apiClient.delete('${AppConfig.recipientsEndpoint}$id/');
      return response.statusCode == 204;
    } catch (e) {
      return false;
    }
  }
}