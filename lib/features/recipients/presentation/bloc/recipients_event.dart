import 'package:equatable/equatable.dart';

import '../../domain/entities/recipient.dart';

abstract class RecipientsEvent extends Equatable {
  const RecipientsEvent();
  
  @override
  List<Object?> get props => [];
}

class FetchRecipients extends RecipientsEvent {}

class FetchRecipient extends RecipientsEvent {
  final int id;
  
  const FetchRecipient(this.id);
  
  @override
  List<Object> get props => [id];
}

class AddRecipientEvent extends RecipientsEvent {   // Rinominato
  final Recipient recipient;
  
  const AddRecipientEvent(this.recipient);
  
  @override
  List<Object> get props => [recipient];
}

class UpdateRecipientEvent extends RecipientsEvent {   // Rinominato
  final Recipient recipient;
  
  const UpdateRecipientEvent(this.recipient);
  
  @override
  List<Object> get props => [recipient];
}

class DeleteRecipientEvent extends RecipientsEvent {   // Rinominato
  final int id;
  
  const DeleteRecipientEvent(this.id);
  
  @override
  List<Object> get props => [id];
}