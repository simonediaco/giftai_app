// lib/features/saved_gifts/domain/repositories/saved_gifts_repository.dart
import '../../domain/entities/saved_gift.dart';

abstract class SavedGiftsRepository {
  Future<List<SavedGift>> getSavedGifts();
  Future<SavedGift> saveGift(SavedGift gift);
  Future<void> deleteSavedGift(int id);
  Future<SavedGift> updateSavedGift(SavedGift gift);
}