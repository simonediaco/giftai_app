// lib/features/saved_gifts/presentation/bloc/saved_gifts_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_saved_gifts.dart';
import '../../domain/usecases/save_gift.dart';
import '../../domain/usecases/delete_saved_gift.dart';
import 'saved_gifts_event.dart';
import 'saved_gifts_state.dart';

class SavedGiftsBloc extends Bloc<SavedGiftsEvent, SavedGiftsState> {
  final GetSavedGifts getSavedGifts;
  final SaveGift saveGift;
  final DeleteSavedGift deleteSavedGift;
  
  SavedGiftsBloc({
    required this.getSavedGifts,
    required this.saveGift,
    required this.deleteSavedGift,
  }) : super(SavedGiftsInitial()) {
    on<FetchSavedGifts>(_onFetchSavedGifts);
    on<AddSavedGift>(_onAddSavedGift);
    on<RemoveSavedGift>(_onRemoveSavedGift);
  }
  
  Future<void> _onFetchSavedGifts(
    FetchSavedGifts event,
    Emitter<SavedGiftsState> emit,
  ) async {
    emit(SavedGiftsLoading());
    try {
      final gifts = await getSavedGifts();
      emit(SavedGiftsLoaded(gifts: gifts));
    } catch (e) {
      emit(SavedGiftsError(message: e.toString()));
    }
  }
  
  Future<void> _onAddSavedGift(
    AddSavedGift event,
    Emitter<SavedGiftsState> emit,
  ) async {
    final currentState = state;
    if (currentState is SavedGiftsLoaded) {
      emit(SavedGiftsLoading());
      try {
        final savedGift = await saveGift(event.gift);
        emit(SavedGiftsLoaded(
          gifts: [...currentState.gifts, savedGift],
        ));
      } catch (e) {
        emit(SavedGiftsError(message: e.toString()));
      }
    }
  }
  
  Future<void> _onRemoveSavedGift(
    RemoveSavedGift event,
    Emitter<SavedGiftsState> emit,
  ) async {
    final currentState = state;
    if (currentState is SavedGiftsLoaded) {
      emit(SavedGiftsLoading());
      try {
        await deleteSavedGift(event.id);
        emit(SavedGiftsLoaded(
          gifts: currentState.gifts.where((gift) => gift.id != event.id).toList(),
        ));
      } catch (e) {
        emit(SavedGiftsError(message: e.toString()));
      }
    }
  }
}