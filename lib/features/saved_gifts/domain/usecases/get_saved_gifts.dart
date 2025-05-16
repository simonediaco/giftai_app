// lib/features/saved_gifts/domain/usecases/get_saved_gifts.dart
import '../entities/saved_gift.dart';
import '../repositories/saved_gifts_repository.dart';

class GetSavedGifts {
  final SavedGiftsRepository _repository;
  
  GetSavedGifts(this._repository);
  
  Future<List<SavedGift>> call() {
    return _repository.getSavedGifts();
  }
}