import 'package:equatable/equatable.dart';
import 'package:giftai/models/recipient_model.dart';

abstract class RecipientState extends Equatable {
  const RecipientState();

  @override
  List<Object?> get props => [];
}

class RecipientInitial extends RecipientState {}

class RecipientLoading extends RecipientState {}

class RecipientLoadSuccess extends RecipientState {
  final List<Recipient> recipients;

  const RecipientLoadSuccess({required this.recipients});

  @override
  List<Object> get props => [recipients];
}

class RecipientLoadFailure extends RecipientState {
  final String message;

  const RecipientLoadFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class RecipientDetailSuccess extends RecipientState {
  final Recipient recipient;

  const RecipientDetailSuccess({required this.recipient});

  @override
  List<Object> get props => [recipient];
}

class RecipientDetailFailure extends RecipientState {
  final String message;

  const RecipientDetailFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class RecipientCreateSuccess extends RecipientState {
  final Recipient recipient;

  const RecipientCreateSuccess({required this.recipient});

  @override
  List<Object> get props => [recipient];
}

class RecipientCreateFailure extends RecipientState {
  final String message;

  const RecipientCreateFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class RecipientUpdateSuccess extends RecipientState {
  final Recipient recipient;

  const RecipientUpdateSuccess({required this.recipient});

  @override
  List<Object> get props => [recipient];
}

class RecipientUpdateFailure extends RecipientState {
  final String message;

  const RecipientUpdateFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class RecipientDeleteSuccess extends RecipientState {}

class RecipientDeleteFailure extends RecipientState {
  final String message;

  const RecipientDeleteFailure({required this.message});

  @override
  List<Object> get props => [message];
}