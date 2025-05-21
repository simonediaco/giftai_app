import 'package:equatable/equatable.dart';

/// Base class for all gift events
abstract class GiftEvent extends Equatable {
  const GiftEvent();

  @override
  List<Object?> get props => [];
}

/// Event to generate gift ideas based on recipient details
class GenerateGiftIdeasEvent extends GiftEvent {
  final String? name;
  final String? age;
  final String? gender;
  final String relation;
  final List<String> interests;
  final String category;
  final String budget;

  const GenerateGiftIdeasEvent({
    this.name,
    this.age,
    this.gender,
    required this.relation,
    required this.interests,
    required this.category,
    required this.budget,
  });

  @override
  List<Object?> get props => [name, age, gender, relation, interests, category, budget];
}

/// Event to generate gift ideas for a saved recipient
class GenerateGiftIdeasForRecipientEvent extends GiftEvent {
  final int recipientId;
  final String category;
  final String budget;

  const GenerateGiftIdeasForRecipientEvent({
    required this.recipientId,
    required this.category,
    required this.budget,
  });

  @override
  List<Object> get props => [recipientId, category, budget];
}

/// Event to save a gift to the user's saved gifts
class SaveGiftEvent extends GiftEvent {
  final int giftId;
  final int? recipientId;

  const SaveGiftEvent({
    required this.giftId,
    this.recipientId,
  });

  @override
  List<Object?> get props => [giftId, recipientId];
}

/// Event to fetch all saved gifts
class FetchSavedGiftsEvent extends GiftEvent {}

/// Event to fetch a specific saved gift
class FetchSavedGiftEvent extends GiftEvent {
  final int giftId;

  const FetchSavedGiftEvent({required this.giftId});

  @override
  List<Object> get props => [giftId];
}

/// Event to delete a saved gift
class DeleteSavedGiftEvent extends GiftEvent {
  final int giftId;

  const DeleteSavedGiftEvent({required this.giftId});

  @override
  List<Object> get props => [giftId];
}

/// Event to update a saved gift
class UpdateSavedGiftEvent extends GiftEvent {
  final int giftId;
  final Map<String, dynamic> updates;

  const UpdateSavedGiftEvent({
    required this.giftId,
    required this.updates,
  });

  @override
  List<Object> get props => [giftId, updates];
}

/// Event to reset the gift state
class ResetGiftStateEvent extends GiftEvent {}

/// Event to fetch saved gifts (alias per compatibilità con codice esistente)
class GiftSavedFetchRequested extends GiftEvent {}

/// Event to request details of a saved gift (alias per compatibilità)
class GiftSavedDetailRequested extends GiftEvent {
  final int giftId;
  final int id; // Alias per compatibilità

  const GiftSavedDetailRequested({required this.giftId, required this.id});

  @override
  List<Object> get props => [giftId, id];
}

/// Event to generate gifts (alias per compatibilità con wizard)
class GiftGenerateRequested extends GiftEvent {
  final String? name;
  final String? age;  // Accetta anche interi convertiti a stringa
  final String? gender;
  final String relation;
  final List<String> interests;
  final String category;
  final String budget;

  const GiftGenerateRequested({
    this.name,
    this.age,
    this.gender,
    required this.relation,
    required this.interests,
    required this.category,
    required this.budget,
  });

  @override
  List<Object?> get props => [name, age, gender, relation, interests, category, budget];
}

/// Event per richiedere il salvataggio di un regalo (alias)
class GiftSaveRequested extends GiftEvent {
  final int giftId;
  final int? recipientId;

  const GiftSaveRequested({
    required this.giftId,
    this.recipientId,
  });

  @override
  List<Object?> get props => [giftId, recipientId];
}