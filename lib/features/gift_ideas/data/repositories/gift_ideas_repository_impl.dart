import '../../domain/entities/gift.dart';
import '../../domain/repositories/gift_ideas_repository.dart';
import '../datasources/gift_ideas_remote_data_source.dart';
import '../models/gift_request.dart';

class GiftIdeasRepositoryImpl implements GiftIdeasRepository {
  final GiftIdeasRemoteDataSource _remoteDataSource;
  
  GiftIdeasRepositoryImpl(this._remoteDataSource);
  
  @override
  Future<List<Gift>> generateGiftIdeas({
    String? name,
    String? age,
    String? gender,
    String? relation,
    List<String>? interests,
    String? category,
    String? budget,
  }) async {
    final request = GiftGenerationRequest(
      name: name,
      age: age,
      gender: gender,
      relation: relation,
      interests: interests,
      category: category,
      budget: budget,
    );
    
    final response = await _remoteDataSource.generateGiftIdeas(request);
    return response.results;
  }
  
  @override
  Future<List<Gift>> generateGiftIdeasForRecipient(
    int recipientId, {
    String? category,
    String? budget,
  }) async {
    final additionalParams = GiftGenerationRequest(
      category: category,
      budget: budget,
    );
    
    final response = await _remoteDataSource.generateGiftIdeasForRecipient(
      recipientId,
      additionalParams,
    );
    return response.results;
  }
}