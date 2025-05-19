import 'package:equatable/equatable.dart';

abstract class GiftIdeasEvent extends Equatable {
  const GiftIdeasEvent();
  
  @override
  List<Object?> get props => [];
}

class GenerateGiftIdeasRequested extends GiftIdeasEvent {
  final String? name;
  final String? age;
  final String? gender;
  final String? relation;
  final List<String>? interests;
  final String? category;
  final String? budget;
  
  const GenerateGiftIdeasRequested({
    this.name,
    this.age,
    required this.gender,
    this.relation,
    this.interests,
    this.category,
    this.budget,
  });
  
  @override
  List<Object?> get props => [name, age, gender, relation, interests, category, budget];
}

class GenerateGiftIdeasForRecipientRequested extends GiftIdeasEvent {
  final int recipientId;
  final String? category;
  final String? budget;
  
  const GenerateGiftIdeasForRecipientRequested({
    required this.recipientId,
    this.category,
    this.budget,
  });
  
  @override
  List<Object?> get props => [recipientId, category, budget];
}

class ClearGiftIdeasRequested extends GiftIdeasEvent {}