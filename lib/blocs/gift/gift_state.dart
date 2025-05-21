import 'package:equatable/equatable.dart';

import '../../models/gift_model.dart';

/// Base class for all gift states
abstract class GiftState extends Equatable {
  const GiftState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class GiftInitialState extends GiftState {}

/// Loading state (alias per compatibilità con codice esistente)
class GiftLoadingState extends GiftState {}
class GiftLoading extends GiftState {}

/// State when gift ideas are successfully loaded
class GiftIdeasLoadedState extends GiftState {
  final List<Gift> gifts;

  const GiftIdeasLoadedState(this.gifts);

  @override
  List<Object> get props => [gifts];
}

/// Alias per compatibilità con codice esistente
class GiftGenerateSuccess extends GiftState {
  final List<Gift> gifts;

  const GiftGenerateSuccess(this.gifts);

  @override
  List<Object> get props => [gifts];
}

/// State when a gift is successfully saved
class GiftSavedState extends GiftState {
  final Gift gift;

  const GiftSavedState(this.gift);

  @override
  List<Object> get props => [gift];
}

/// State when saved gifts are successfully loaded (e alias per compatibilità)
class SavedGiftsLoadedState extends GiftState {
  final List<Gift> gifts;

  const SavedGiftsLoadedState(this.gifts);

  @override
  List<Object> get props => [gifts];
}
class GiftSavedLoadSuccess extends GiftState {
  final List<Gift> gifts;

  const GiftSavedLoadSuccess(this.gifts);

  @override
  List<Object> get props => [gifts];
}

/// State when a specific saved gift is successfully loaded
class SavedGiftLoadedState extends GiftState {
  final Gift gift;

  const SavedGiftLoadedState(this.gift);

  @override
  List<Object> get props => [gift];
}

/// Alias for SavedGiftLoadedState (per compatibilità codice esistente)
class GiftSavedDetailSuccess extends GiftState {
  final Gift gift;

  const GiftSavedDetailSuccess(this.gift);

  @override
  List<Object> get props => [gift];
}

/// State when a gift is successfully deleted
class GiftDeletedState extends GiftState {
  final int giftId;

  const GiftDeletedState(this.giftId);

  @override
  List<Object> get props => [giftId];
}

/// State when a gift is successfully updated
class GiftUpdatedState extends GiftState {
  final Gift gift;

  const GiftUpdatedState(this.gift);

  @override
  List<Object> get props => [gift];
}

/// Error state (e alias per compatibilità)
class GiftErrorState extends GiftState {
  final String message;

  const GiftErrorState(this.message);

  @override
  List<Object> get props => [message];
}
class GiftSavedLoadFailure extends GiftState {
  final String message;

  const GiftSavedLoadFailure(this.message);

  @override
  List<Object> get props => [message];
}
class GiftSavedDetailFailure extends GiftState {
  final String message;

  const GiftSavedDetailFailure(this.message);

  @override
  List<Object> get props => [message];
}
class GiftGenerateFailure extends GiftState {
  final String message;

  const GiftGenerateFailure(this.message);

  @override
  List<Object> get props => [message];
}