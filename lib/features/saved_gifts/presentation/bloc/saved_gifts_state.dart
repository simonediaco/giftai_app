// lib/features/saved_gifts/presentation/bloc/saved_gifts_state.dart
import 'package:equatable/equatable.dart';

import '../../domain/entities/saved_gift.dart';

abstract class SavedGiftsState extends Equatable {
  const SavedGiftsState();
  
  @override
  List<Object?> get props => [];
}

class SavedGiftsInitial extends SavedGiftsState {}

class SavedGiftsLoading extends SavedGiftsState {}

class SavedGiftsLoaded extends SavedGiftsState {
  final List<SavedGift> gifts;
  
  const SavedGiftsLoaded({required this.gifts});
  
  @override
  List<Object> get props => [gifts];
}

class SavedGiftsError extends SavedGiftsState {
  final String message;
  
  const SavedGiftsError({required this.message});
  
  @override
  List<Object> get props => [message];
}