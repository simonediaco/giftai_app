import 'package:equatable/equatable.dart';
import 'package:giftai/models/gift_model.dart';

abstract class GiftState extends Equatable {
  const GiftState();

  @override
  List<Object?> get props => [];
}

class GiftInitial extends GiftState {}

class GiftLoading extends GiftState {}

class GiftGenerateSuccess extends GiftState {
  final List<GiftModel> gifts;

  const GiftGenerateSuccess({required this.gifts});

  @override
  List<Object> get props => [gifts];
}

class GiftGenerateFailure extends GiftState {
  final String message;

  const GiftGenerateFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class GiftSavedLoadSuccess extends GiftState {
  final List<GiftModel> gifts;

  const GiftSavedLoadSuccess({required this.gifts});

  @override
  List<Object> get props => [gifts];
}

class GiftSavedLoadFailure extends GiftState {
  final String message;

  const GiftSavedLoadFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class GiftSavedDetailSuccess extends GiftState {
  final GiftModel gift;

  const GiftSavedDetailSuccess({required this.gift});

  @override
  List<Object> get props => [gift];
}

class GiftSavedDetailFailure extends GiftState {
  final String message;

  const GiftSavedDetailFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class GiftSaveSuccess extends GiftState {
  final GiftModel gift;

  const GiftSaveSuccess({required this.gift});

  @override
  List<Object> get props => [gift];
}

class GiftSaveFailure extends GiftState {
  final String message;

  const GiftSaveFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class GiftSavedUpdateSuccess extends GiftState {
  final GiftModel gift;

  const GiftSavedUpdateSuccess({required this.gift});

  @override
  List<Object> get props => [gift];
}

class GiftSavedUpdateFailure extends GiftState {
  final String message;

  const GiftSavedUpdateFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class GiftSavedDeleteSuccess extends GiftState {}

class GiftSavedDeleteFailure extends GiftState {
  final String message;

  const GiftSavedDeleteFailure({required this.message});

  @override
  List<Object> get props => [message];
}