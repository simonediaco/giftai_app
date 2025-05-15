import 'package:equatable/equatable.dart';

import '../../domain/entities/gift.dart';

abstract class GiftIdeasState extends Equatable {
  const GiftIdeasState();
  
  @override
  List<Object?> get props => [];
}

class GiftIdeasInitial extends GiftIdeasState {}

class GiftIdeasLoading extends GiftIdeasState {}

class GiftIdeasGenerated extends GiftIdeasState {
  final List<Gift> gifts;
  
  const GiftIdeasGenerated(this.gifts);
  
  @override
  List<Object> get props => [gifts];
}

class GiftIdeasError extends GiftIdeasState {
  final String message;
  
  const GiftIdeasError(this.message);
  
  @override
  List<Object> get props => [message];
}