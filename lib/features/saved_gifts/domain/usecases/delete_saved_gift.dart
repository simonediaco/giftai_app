// lib/features/saved_gifts/domain/usecases/delete_saved_gift.dart
import '../repositories/saved_gifts_repository.dart';

class DeleteSavedGift {
  final SavedGiftsRepository _repository;
  
  DeleteSavedGift(this._repository);
  
  Future<void> call(int id) {
    return _repository.deleteSavedGift(id);
  }
}