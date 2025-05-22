import '../entities/gift.dart';
import '../repositories/gift_ideas_repository.dart';

class GenerateGiftIdeas {
  final GiftIdeasRepository _repository;
  
  GenerateGiftIdeas(this._repository);
  
  Future<List<Gift>> call({
    String? name,
    String? age,
    String? gender,
    String? relation,
    List<String>? interests,
    String? category,
    int? minPrice,
    int? maxPrice,
  }) {
    return _repository.generateGiftIdeas(
      name: name,
      age: age,
      gender: gender,
      relation: relation,
      interests: interests,
      category: category,
      minPrice: minPrice,
      maxPrice: maxPrice,
    );
  }
}