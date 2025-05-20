import 'package:equatable/equatable.dart';
import 'package:giftai/models/recipient_model.dart';

abstract class RecipientEvent extends Equatable {
  const RecipientEvent();

  @override
  List<Object?> get props => [];
}

class RecipientFetchRequested extends RecipientEvent {}

class RecipientDetailRequested extends RecipientEvent {
  final int id;

  const RecipientDetailRequested({required this.id});

  @override
  List<Object> get props => [id];
}

class RecipientCreateRequested extends RecipientEvent {
  final RecipientModel recipient;

  const RecipientCreateRequested({required this.recipient});

  @override
  List<Object> get props => [recipient];
}

class RecipientUpdateRequested extends RecipientEvent {
  final RecipientModel recipient;

  const RecipientUpdateRequested({required this.recipient});

  @override
  List<Object> get props => [recipient];
}

class RecipientDeleteRequested extends RecipientEvent {
  final int id;

  const RecipientDeleteRequested({required this.id});

  @override
  List<Object> get props => [id];
}