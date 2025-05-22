
import '../entities/gift.dart';

abstract class GiftIdeasRepository {
  Future<List<Gift>> generateGiftIdeas({
    String? name,
    String? age,
    String? gender,
    String? relation,
    List<String>? interests,
    String? category,
    int? minPrice,
    int? maxPrice,
  });
  
  Future<List<Gift>> generateGiftIdeasForRecipient(
    int recipientId, {
    String? category,
    int? minPrice,
    int? maxPrice,
  });
}
