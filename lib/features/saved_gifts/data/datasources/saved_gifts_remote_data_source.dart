// lib/features/saved_gifts/data/datasources/saved_gifts_remote_data_source.dart
import '../../../../core/api/api_client.dart';
import '../../../../core/errors/api_error.dart';
import '../models/saved_gift_model.dart';

abstract class SavedGiftsRemoteDataSource {
  Future<List<SavedGiftModel>> getSavedGifts();
  Future<SavedGiftModel> saveGift(Map<String, dynamic> giftData);
  Future<void> deleteSavedGift(int id);
  Future<SavedGiftModel> updateSavedGift(int id, Map<String, dynamic> giftData);
}

class SavedGiftsRemoteDataSourceImpl implements SavedGiftsRemoteDataSource {
  final ApiClient _apiClient;
  
  SavedGiftsRemoteDataSourceImpl(this._apiClient);
  
  @override
  Future<List<SavedGiftModel>> getSavedGifts() async {
    try {
      final response = await _apiClient.get('/api/saved-gifts/');
      return (response.data as List)
          .map((item) => SavedGiftModel.fromJson(item))
          .toList();
    } on ApiError {
      rethrow;
    } catch (e) {
      throw ApiError(
        message: 'Si è verificato un errore durante il recupero dei regali salvati',
        statusCode: 500,
      );
    }
  }
  
  @override
  Future<SavedGiftModel> saveGift(Map<String, dynamic> giftData) async {
    try {
      final response = await _apiClient.post(
        '/api/saved-gifts/',
        data: giftData,
      );
      return SavedGiftModel.fromJson(response.data);
    } on ApiError {
      rethrow;
    } catch (e) {
      throw ApiError(
        message: 'Si è verificato un errore durante il salvataggio del regalo',
        statusCode: 500,
      );
    }
  }
  
  @override
  Future<void> deleteSavedGift(int id) async {
    try {
      await _apiClient.delete('/api/saved-gifts/$id/');
    } on ApiError {
      rethrow;
    } catch (e) {
      throw ApiError(
        message: 'Si è verificato un errore durante l\'eliminazione del regalo',
        statusCode: 500,
      );
    }
  }
  
  @override
  Future<SavedGiftModel> updateSavedGift(int id, Map<String, dynamic> giftData) async {
    try {
      final response = await _apiClient.put(
        '/api/saved-gifts/$id/',
        data: giftData,
      );
      return SavedGiftModel.fromJson(response.data);
    } on ApiError {
      rethrow;
    } catch (e) {
      throw ApiError(
        message: 'Si è verificato un errore durante l\'aggiornamento del regalo',
        statusCode: 500,
      );
    }
  }
}