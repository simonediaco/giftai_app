// lib/features/saved_gifts/data/repositories/saved_gifts_repository_impl.dart
import '../../domain/entities/saved_gift.dart';
import '../../domain/repositories/saved_gifts_repository.dart';
import '../datasources/saved_gifts_remote_data_source.dart';
import '../models/saved_gift_model.dart';

class SavedGiftsRepositoryImpl implements SavedGiftsRepository {
  final SavedGiftsRemoteDataSource _remoteDataSource;
  
  SavedGiftsRepositoryImpl(this._remoteDataSource);
  
  @override
  Future<List<SavedGift>> getSavedGifts() async {
    final savedGifts = await _remoteDataSource.getSavedGifts();
    return savedGifts;
  }
  
  @override
  Future<SavedGift> saveGift(SavedGift gift) async {
    final savedGiftModel = SavedGiftModel(
      id: gift.id,
      name: gift.name,
      price: gift.price,
      match: gift.match,
      image: gift.image,
      category: gift.category,
      dateAdded: gift.dateAdded,
      notes: gift.notes,
    );
    
    final result = await _remoteDataSource.saveGift(
      (savedGiftModel as SavedGiftModel).toJson(),
    );
    return result;
  }
  
  @override
  Future<void> deleteSavedGift(int id) async {
    await _remoteDataSource.deleteSavedGift(id);
  }
  
  @override
  Future<SavedGift> updateSavedGift(SavedGift gift) async {
    final savedGiftModel = SavedGiftModel(
      id: gift.id,
      name: gift.name,
      price: gift.price,
      match: gift.match,
      image: gift.image,
      category: gift.category,
      dateAdded: gift.dateAdded,
      notes: gift.notes,
    );
    
    final result = await _remoteDataSource.updateSavedGift(
      gift.id,
      (savedGiftModel as SavedGiftModel).toJson(),
    );
    return result;
  }
}