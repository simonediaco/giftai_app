import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/gift_model.dart';
import '../../repositories/gift_repository.dart';
import 'gift_event.dart';
import 'gift_state.dart';

/// BLoC for managing gift-related states and events
class GiftBloc extends Bloc<GiftEvent, GiftState> {
  final GiftRepository giftRepository;

  GiftBloc({required this.giftRepository}) : super(GiftInitialState()) {
    // Register event handlers
    on<GenerateGiftIdeasEvent>(_onGenerateGiftIdeas);
    on<GenerateGiftIdeasForRecipientEvent>(_onGenerateGiftIdeasForRecipient);
    on<SaveGiftEvent>(_onSaveGift);
    on<FetchSavedGiftsEvent>(_onFetchSavedGifts);
    on<FetchSavedGiftEvent>(_onFetchSavedGift);
    on<DeleteSavedGiftEvent>(_onDeleteSavedGift);
    on<UpdateSavedGiftEvent>(_onUpdateSavedGift);
    on<ResetGiftStateEvent>(_onResetState);
    
    // Alias per compatibilità con codice esistente
    on<GiftSavedFetchRequested>(_onGiftSavedFetchRequested);
    on<GiftSavedDetailRequested>(_onGiftSavedDetailRequested);
    on<GiftGenerateRequested>(_onGiftGenerateRequested);
    on<GiftSaveRequested>(_onGiftSaveRequested);
  }

  /// Handler for GenerateGiftIdeasEvent
  Future<void> _onGenerateGiftIdeas(
      GenerateGiftIdeasEvent event, Emitter<GiftState> emit) async {
    try {
      emit(GiftLoadingState());

      final gifts = await giftRepository.generateGiftIdeas(
        name: event.name,
        age: event.age,
        gender: event.gender,
        relation: event.relation,
        interests: event.interests,
        category: event.category,
        budget: event.budget,
      );

      emit(GiftIdeasLoadedState(gifts));
    } catch (e) {
      emit(GiftErrorState('Errore durante la generazione dei regali: $e'));
    }
  }

  /// Handler for GenerateGiftIdeasForRecipientEvent
  Future<void> _onGenerateGiftIdeasForRecipient(
      GenerateGiftIdeasForRecipientEvent event, Emitter<GiftState> emit) async {
    try {
      emit(GiftLoadingState());

      final gifts = await giftRepository.generateGiftIdeasForRecipient(
        recipientId: event.recipientId,
        category: event.category,
        budget: event.budget,
      );

      emit(GiftIdeasLoadedState(gifts));
    } catch (e) {
      emit(GiftErrorState('Errore durante la generazione dei regali: $e'));
    }
  }

  /// Handler for SaveGiftEvent
  Future<void> _onSaveGift(SaveGiftEvent event, Emitter<GiftState> emit) async {
    try {
      emit(GiftLoadingState());

      // Get the current state to find the gift to save
      if (state is GiftIdeasLoadedState) {
        final currentGifts = (state as GiftIdeasLoadedState).gifts;
        final giftToSave = currentGifts.firstWhere((g) => g.id == event.giftId);

        final savedGift = await giftRepository.saveGift(
          giftToSave,
          recipientId: event.recipientId,
        );

        emit(GiftSavedState(savedGift));
      } else {
        throw Exception('Non ci sono regali da salvare');
      }
    } catch (e) {
      emit(GiftErrorState('Errore durante il salvataggio del regalo: $e'));
    }
  }

  /// Handler for FetchSavedGiftsEvent
  Future<void> _onFetchSavedGifts(
      FetchSavedGiftsEvent event, Emitter<GiftState> emit) async {
    try {
      emit(GiftLoadingState());

      final gifts = await giftRepository.getSavedGifts();
      emit(SavedGiftsLoadedState(gifts));
    } catch (e) {
      emit(GiftErrorState('Errore durante il caricamento dei regali salvati: $e'));
    }
  }

  /// Handler for FetchSavedGiftEvent
  Future<void> _onFetchSavedGift(
      FetchSavedGiftEvent event, Emitter<GiftState> emit) async {
    try {
      emit(GiftLoadingState());

      final gift = await giftRepository.getSavedGiftById(event.giftId);
      emit(SavedGiftLoadedState(gift));
    } catch (e) {
      emit(GiftErrorState('Errore durante il caricamento del regalo: $e'));
    }
  }

  /// Handler for DeleteSavedGiftEvent
  Future<void> _onDeleteSavedGift(
      DeleteSavedGiftEvent event, Emitter<GiftState> emit) async {
    try {
      emit(GiftLoadingState());

      final success = await giftRepository.deleteSavedGift(event.giftId);
      if (success) {
        emit(GiftDeletedState(event.giftId));
      } else {
        throw Exception('Eliminazione fallita');
      }
    } catch (e) {
      emit(GiftErrorState('Errore durante l\'eliminazione del regalo: $e'));
    }
  }

  /// Handler for UpdateSavedGiftEvent
  Future<void> _onUpdateSavedGift(
      UpdateSavedGiftEvent event, Emitter<GiftState> emit) async {
    try {
      emit(GiftLoadingState());

      final updatedGift = await giftRepository.updateSavedGift(
        event.giftId,
        event.updates,
      );

      emit(GiftUpdatedState(updatedGift));
    } catch (e) {
      emit(GiftErrorState('Errore durante l\'aggiornamento del regalo: $e'));
    }
  }

  /// Handler for ResetGiftStateEvent
  void _onResetState(ResetGiftStateEvent event, Emitter<GiftState> emit) {
    emit(GiftInitialState());
  }
  
  /// Handler per GiftSavedFetchRequested (alias di FetchSavedGiftsEvent)
  Future<void> _onGiftSavedFetchRequested(
      GiftSavedFetchRequested event, Emitter<GiftState> emit) async {
    try {
      emit(GiftLoadingState());

      final gifts = await giftRepository.getSavedGifts();
      emit(GiftSavedLoadSuccess(gifts));
    } catch (e) {
      emit(GiftSavedLoadFailure('Errore durante il caricamento dei regali salvati: $e'));
    }
  }

  /// Handler per GiftSavedDetailRequested (alias di FetchSavedGiftEvent)
  Future<void> _onGiftSavedDetailRequested(
      GiftSavedDetailRequested event, Emitter<GiftState> emit) async {
    try {
      emit(GiftLoadingState());

      // Usa l'ID fornito (nell'evento il giftId e l'id sono lo stesso valore)
      final gift = await giftRepository.getSavedGiftById(event.giftId);
      emit(GiftSavedDetailSuccess(gift));
    } catch (e) {
      emit(GiftSavedDetailFailure('Errore durante il caricamento del regalo: $e'));
    }
  }

  /// Handler per GiftGenerateRequested (alias di GenerateGiftIdeasEvent)
  Future<void> _onGiftGenerateRequested(
      GiftGenerateRequested event, Emitter<GiftState> emit) async {
    try {
      emit(GiftLoadingState());

      final gifts = await giftRepository.generateGiftIdeas(
        name: event.name,
        age: event.age,
        gender: event.gender,
        relation: event.relation,
        interests: event.interests,
        category: event.category,
        budget: event.budget,
      );

      // Emetti sia lo stato standard che l'alias per compatibilità
      emit(GiftGenerateSuccess(gifts));
    } catch (e) {
      emit(GiftGenerateFailure('Errore durante la generazione dei regali: $e'));
    }
  }
  
  /// Handler per GiftSaveRequested (alias di SaveGiftEvent)
  Future<void> _onGiftSaveRequested(
      GiftSaveRequested event, Emitter<GiftState> emit) async {
    try {
      emit(GiftLoadingState());

      // Get the current state to find the gift to save
      if (state is GiftIdeasLoadedState) {
        final currentGifts = (state as GiftIdeasLoadedState).gifts;
        final giftToSave = currentGifts.firstWhere((g) => g.id == event.giftId);

        final savedGift = await giftRepository.saveGift(
          giftToSave,
          recipientId: event.recipientId,
        );

        emit(GiftSavedState(savedGift));
      } else {
        throw Exception('Non ci sono regali da salvare');
      }
    } catch (e) {
      emit(GiftErrorState('Errore durante il salvataggio del regalo: $e'));
    }
  }
}