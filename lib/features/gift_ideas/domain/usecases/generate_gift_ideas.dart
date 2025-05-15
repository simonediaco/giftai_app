import '../entities/gift.dart';
import '../repositories/gift_ideas_repository.dart';

class GenerateGiftIdeas {
  final GiftIdeasRepository _repository;
  
  GenerateGiftIdeas(this._repository);
  
  Future<List<Gift>> call({
    String? name,
    String? age,
    String? relation,
    List<String>? interests,
    String? category,
    String? budget,
  }) {
    return _repository.generateGiftIdeas(
      name: name,
      age: age,
      relation: relation,
      interests: interests,
      category: category,
      budget: budget,
    );
  }
}