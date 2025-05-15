import '../../../../core/api/api_client.dart';
import '../../../../core/errors/api_error.dart';
import '../models/gift_generation_response.dart';
import '../models/gift_request.dart';

abstract class GiftIdeasRemoteDataSource {
  Future<GiftGenerationResponse> generateGiftIdeas(GiftGenerationRequest request);
  Future<GiftGenerationResponse> generateGiftIdeasForRecipient(int recipientId, GiftGenerationRequest? additionalParams);
}

class GiftIdeasRemoteDataSourceImpl implements GiftIdeasRemoteDataSource {
  final ApiClient _apiClient;
  
  GiftIdeasRemoteDataSourceImpl(this._apiClient);
  
  @override
  Future<GiftGenerationResponse> generateGiftIdeas(GiftGenerationRequest request) async {
    try {
      final response = await _apiClient.post(
        '/api/generate-gift-ideas/',
        data: request.toJson(),
      );
      return GiftGenerationResponse.fromJson(response.data);
    } on ApiError {
      rethrow;
    } catch (e) {
      throw ApiError(
        message: 'Si è verificato un errore durante la generazione delle idee regalo',
        statusCode: 500,
      );
    }
  }
  
  @override
  Future<GiftGenerationResponse> generateGiftIdeasForRecipient(
    int recipientId, 
    GiftGenerationRequest? additionalParams,
  ) async {
    try {
      final response = await _apiClient.post(
        '/api/generate-gift-ideas/recipient/$recipientId/',
        data: additionalParams?.toJson() ?? {},
      );
      return GiftGenerationResponse.fromJson(response.data);
    } on ApiError {
      rethrow;
    } catch (e) {
      throw ApiError(
        message: 'Si è verificato un errore durante la generazione delle idee regalo',
        statusCode: 500,
      );
    }
  }
}