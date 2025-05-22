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
  final int? minPrice;
  final int? maxPrice;

  const GenerateGiftIdeasRequested({
    this.name,
    this.age,
    required this.gender,
    this.relation,
    this.interests,
    this.category,
    this.minPrice,
    this.maxPrice,
  });

  @override
  List<Object?> get props => [name, age, gender, relation, interests, category, minPrice, maxPrice];
}

class GenerateGiftIdeasForRecipientRequested extends GiftIdeasEvent {
  final int recipientId;
  final String? category;
  final int? minPrice;
  final int? maxPrice;

  const GenerateGiftIdeasForRecipientRequested({
    required this.recipientId,
    this.category,
    this.minPrice,
    this.maxPrice,
  });

  @override
  List<Object?> get props => [recipientId, category, minPrice, maxPrice];
}

class ClearGiftIdeasRequested extends GiftIdeasEvent {}