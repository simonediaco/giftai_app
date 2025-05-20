import 'package:giftai/config/app_config.dart';
import 'package:giftai/models/gift_model.dart';
import 'package:giftai/services/api_client.dart';

class GiftRepository {
  final ApiClient _apiClient;

  GiftRepository(this._apiClient);

  // Genera idee regalo senza destinatario
  Future<List<GiftModel>> generateGiftIdeas({
    String? name,
    int? age,
    required String gender,
    required String relation,
    required List<String> interests,
    required String category,
    required String budget,
  }) async {
    try {
      final response = await _apiClient.post(
        AppConfig.generateGiftIdeasEndpoint,
        data: {
          'name': name,
          'age': age,
          'gender': gender,
          'relation': relation,
          'interests': interests,
          'category': category,
          'budget': budget,
        },
      );
      
     if (response.statusCode == 200 && response.data['results'] != null) {
          return (response.data['results'] as List)
              .map((json) => GiftModel.fromJson(json))
              .toList();
        }
        
        return [];
      } catch (e) {
        rethrow;
      }
    }

  // Genera idee regalo per un destinatario specifico
  Future<List<GiftModel>> generateGiftIdeasForRecipient({
    required int recipientId,
    required String category,
    required String budget,
  }) async {
    try {
      final response = await _apiClient.post(
        '${AppConfig.generateGiftIdeasEndpoint}recipient/$recipientId/',
        data: {
          'category': category,
          'budget': budget,
        },
      );
      
      if (response.statusCode == 200 && response.data['results'] != null) {
        return (response.data['results'] as List)
            .map((json) => GiftModel.fromJson(json))
            .toList();
      }
      
      return [];
    } catch (e) {
      rethrow;
    }
  }

  // Ottieni lista regali salvati
  Future<List<GiftModel>> getSavedGifts() async {
    try {
      final response = await _apiClient.get(AppConfig.savedGiftsEndpoint);
      
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => GiftModel.fromJson(json))
            .toList();
      }
      
      return [];
    } catch (e) {
      return [];
    }
  }

  // Salva un regalo
  Future<GiftModel?> saveGift(GiftModel gift) async {
    try {
      final response = await _apiClient.post(
        AppConfig.savedGiftsEndpoint,
        data: gift.toJson(),
      );
      
      if (response.statusCode == 201) {
        return GiftModel.fromJson(response.data);
      }
      
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Ottieni dettaglio regalo salvato
  Future<GiftModel?> getSavedGift(int id) async {
    try {
      final response = await _apiClient.get('${AppConfig.savedGiftsEndpoint}$id/');
      
      if (response.statusCode == 200) {
        return GiftModel.fromJson(response.data);
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  // Aggiorna regalo salvato
  Future<GiftModel?> updateSavedGift(GiftModel gift) async {
    try {
      if (gift.id == null) {
        throw Exception('Cannot update gift without ID');
      }
      
      final response = await _apiClient.patch(
        '${AppConfig.savedGiftsEndpoint}${gift.id}/',
        data: gift.toJson(),
      );
      
      if (response.statusCode == 200) {
        return GiftModel.fromJson(response.data);
      }
      
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Elimina regalo salvato
  Future<bool> deleteSavedGift(int id) async {
    try {
      final response = await _apiClient.delete('${AppConfig.savedGiftsEndpoint}$id/');
      return response.statusCode == 204;
    } catch (e) {
      return false;
    }
  }
}