// lib/features/saved_gifts/domain/usecases/save_gift.dart
import '../entities/saved_gift.dart';
import '../repositories/saved_gifts_repository.dart';

class SaveGift {
  final SavedGiftsRepository _repository;
  
  SaveGift(this._repository);
  
  Future<SavedGift> call(SavedGift gift) {
    return _repository.saveGift(gift);
  }
}