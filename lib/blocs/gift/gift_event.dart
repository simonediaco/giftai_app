import 'package:equatable/equatable.dart';
import 'package:giftai/models/gift_model.dart';

abstract class GiftEvent extends Equatable {
  const GiftEvent();

  @override
  List<Object?> get props => [];
}

class GiftGenerateRequested extends GiftEvent {
  final String? name;
  final int? age;
  final String gender;
  final String relation;
  final List<String> interests;
  final String category;
  final String budget;

  const GiftGenerateRequested({
    this.name,
    this.age,
    required this.gender,
    required this.relation,
    required this.interests,
    required this.category,
    required this.budget,
  });

  @override
  List<Object?> get props => [name, age, gender, relation, interests, category, budget];
}

class GiftGenerateForRecipientRequested extends GiftEvent {
  final int recipientId;
  final String category;
  final String budget;

  const GiftGenerateForRecipientRequested({
    required this.recipientId,
    required this.category,
    required this.budget,
  });

  @override
  List<Object> get props => [recipientId, category, budget];
}

class GiftSavedFetchRequested extends GiftEvent {}

class GiftSavedDetailRequested extends GiftEvent {
  final int id;

  const GiftSavedDetailRequested({required this.id});

  @override
  List<Object> get props => [id];
}

class GiftSaveRequested extends GiftEvent {
  final GiftModel gift;

  const GiftSaveRequested({required this.gift});

  @override
  List<Object> get props => [gift];
}

class GiftSavedUpdateRequested extends GiftEvent {
  final GiftModel gift;

  const GiftSavedUpdateRequested({required this.gift});

  @override
  List<Object> get props => [gift];
}

class GiftSavedDeleteRequested extends GiftEvent {
  final int id;

  const GiftSavedDeleteRequested({required this.id});

  @override
  List<Object> get props => [id];
}