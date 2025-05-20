import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giftai/blocs/gift/gift_event.dart';
import 'package:giftai/blocs/gift/gift_state.dart';
import 'package:giftai/repositories/gift_repository.dart';

class GiftBloc extends Bloc<GiftEvent, GiftState> {
  final GiftRepository _giftRepository;

  GiftBloc({required GiftRepository giftRepository})
      : _giftRepository = giftRepository,
        super(GiftInitial()) {
    on<GiftGenerateRequested>(_onGiftGenerateRequested);
    on<GiftGenerateForRecipientRequested>(_onGiftGenerateForRecipientRequested);
    on<GiftSavedFetchRequested>(_onGiftSavedFetchRequested);
    on<GiftSavedDetailRequested>(_onGiftSavedDetailRequested);
    on<GiftSaveRequested>(_onGiftSaveRequested);
    on<GiftSavedUpdateRequested>(_onGiftSavedUpdateRequested);
    on<GiftSavedDeleteRequested>(_onGiftSavedDeleteRequested);
  }

  Future<void> _onGiftGenerateRequested(
    GiftGenerateRequested event,
    Emitter<GiftState> emit,
  ) async {
    emit(GiftLoading());
    try {
      final gifts = await _giftRepository.generateGiftIdeas(
        name: event.name,
        age: event.age,
        gender: event.gender,
        relation: event.relation,
        interests: event.interests,
        category: event.category,
        budget: event.budget,
      );
      emit(GiftGenerateSuccess(gifts: gifts));
    } catch (e) {
      emit(GiftGenerateFailure(message: e.toString()));
    }
  }

  Future<void> _onGiftGenerateForRecipientRequested(
    GiftGenerateForRecipientRequested event,
    Emitter<GiftState> emit,
  ) async {
    emit(GiftLoading());
    try {
      final gifts = await _giftRepository.generateGiftIdeasForRecipient(
        recipientId: event.recipientId,
        category: event.category,
        budget: event.budget,
      );
      emit(GiftGenerateSuccess(gifts: gifts));
    } catch (e) {
      emit(GiftGenerateFailure(message: e.toString()));
    }
  }

  Future<void> _onGiftSavedFetchRequested(
    GiftSavedFetchRequested event,
    Emitter<GiftState> emit,
  ) async {
    emit(GiftLoading());
    try {
      final gifts = await _giftRepository.getSavedGifts();
      emit(GiftSavedLoadSuccess(gifts: gifts));
    } catch (e) {
      emit(GiftSavedLoadFailure(message: e.toString()));
    }
  }

  Future<void> _onGiftSavedDetailRequested(
    GiftSavedDetailRequested event,
    Emitter<GiftState> emit,
  ) async {
    emit(GiftLoading());
    try {
      final gift = await _giftRepository.getSavedGift(event.id);
      if (gift != null) {
        emit(GiftSavedDetailSuccess(gift: gift));
      } else {
        emit(const GiftSavedDetailFailure(message: 'Regalo non trovato.'));
      }
    } catch (e) {
      emit(GiftSavedDetailFailure(message: e.toString()));
    }
  }

  Future<void> _onGiftSaveRequested(
    GiftSaveRequested event,
    Emitter<GiftState> emit,
  ) async {
    emit(GiftLoading());
    try {
      final gift = await _giftRepository.saveGift(event.gift);
      if (gift != null) {
        emit(GiftSaveSuccess(gift: gift));
      } else {
        emit(const GiftSaveFailure(message: 'Impossibile salvare il regalo.'));
      }
    } catch (e) {
      emit(GiftSaveFailure(message: e.toString()));
    }
  }

  Future<void> _onGiftSavedUpdateRequested(
    GiftSavedUpdateRequested event,
    Emitter<GiftState> emit,
  ) async {
    emit(GiftLoading());
    try {
      final gift = await _giftRepository.updateSavedGift(event.gift);
      if (gift != null) {
        emit(GiftSavedUpdateSuccess(gift: gift));
      } else {
        emit(const GiftSavedUpdateFailure(message: 'Impossibile aggiornare il regalo.'));
      }
    } catch (e) {
      emit(GiftSavedUpdateFailure(message: e.toString()));
    }
  }

  Future<void> _onGiftSavedDeleteRequested(
    GiftSavedDeleteRequested event,
    Emitter<GiftState> emit,
  ) async {
    emit(GiftLoading());
    try {
      final success = await _giftRepository.deleteSavedGift(event.id);
      if (success) {
        emit(GiftSavedDeleteSuccess());
      } else {
        emit(const GiftSavedDeleteFailure(message: 'Impossibile eliminare il regalo.'));
      }
    } catch (e) {
      emit(GiftSavedDeleteFailure(message: e.toString()));
    }
  }
}