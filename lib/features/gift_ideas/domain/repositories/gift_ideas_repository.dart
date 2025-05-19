import '../entities/gift.dart';
import '../../data/models/gift_request.dart';

abstract class GiftIdeasRepository {
  Future<List<Gift>> generateGiftIdeas({
    String? name,
    String? age,
    String? gender,
    String? relation,
    List<String>? interests,
    String? category,
    String? budget,
  });
  
  Future<List<Gift>> generateGiftIdeasForRecipient(
    int recipientId, {
    String? category,
    String? budget,
  });
}