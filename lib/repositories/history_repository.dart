import 'package:giftai/config/app_config.dart';
import 'package:giftai/models/history_model.dart';
import 'package:giftai/services/api_client.dart';

class HistoryRepository {
  final ApiClient _apiClient;

  HistoryRepository(this._apiClient);

  // Ottieni cronologia delle richieste
  Future<List<HistoryModel>> getHistory() async {
    try {
      final response = await _apiClient.get(AppConfig.historyEndpoint);
      
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => HistoryModel.fromJson(json))
            .toList();
      }
      
      return [];
    } catch (e) {
      return [];
    }
  }

  // Ottieni dettaglio storico
  Future<HistoryModel?> getHistoryDetail(int id) async {
    try {
      final response = await _apiClient.get('${AppConfig.historyEndpoint}$id/');
      
      if (response.statusCode == 200) {
        return HistoryModel.fromJson(response.data);
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }
}