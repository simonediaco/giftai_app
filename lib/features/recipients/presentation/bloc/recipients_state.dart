// lib/features/recipients/presentation/bloc/recipients_state.dart
import 'package:equatable/equatable.dart';

import '../../domain/entities/recipient.dart';

abstract class RecipientsState extends Equatable {
  const RecipientsState();
  
  @override
  List<Object?> get props => [];
}

class RecipientsInitial extends RecipientsState {}

class RecipientsLoading extends RecipientsState {}

class RecipientsLoaded extends RecipientsState {
  final List<Recipient> recipients;
  
  const RecipientsLoaded({required this.recipients});
  
  @override
  List<Object> get props => [recipients];
}

class RecipientLoaded extends RecipientsState {
  final Recipient recipient;
  
  const RecipientLoaded({required this.recipient});
  
  @override
  List<Object> get props => [recipient];
}

class RecipientSaved extends RecipientsState {
  final Recipient recipient;
  
  const RecipientSaved({required this.recipient});
  
  @override
  List<Object> get props => [recipient];
}

class RecipientDeleted extends RecipientsState {}

class RecipientsError extends RecipientsState {
  final String message;
  
  const RecipientsError({required this.message});
  
  @override
  List<Object> get props => [message];
}