// lib/features/saved_gifts/presentation/bloc/saved_gifts_event.dart
import 'package:equatable/equatable.dart';

import '../../domain/entities/saved_gift.dart';

abstract class SavedGiftsEvent extends Equatable {
  const SavedGiftsEvent();
  
  @override
  List<Object?> get props => [];
}

class FetchSavedGifts extends SavedGiftsEvent {}

class AddSavedGift extends SavedGiftsEvent {
  final SavedGift gift;
  
  const AddSavedGift(this.gift);
  
  @override
  List<Object> get props => [gift];
}

class RemoveSavedGift extends SavedGiftsEvent {
  final int id;
  
  const RemoveSavedGift(this.id);
  
  @override
  List<Object> get props => [id];
}