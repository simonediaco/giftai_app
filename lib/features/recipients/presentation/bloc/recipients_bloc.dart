import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/create_recipient.dart';
import '../../domain/usecases/delete_recipient.dart' as usecases;
import '../../domain/usecases/get_recipient.dart';
import '../../domain/usecases/get_recipients.dart';
import '../../domain/usecases/update_recipient.dart' as usecases;
import 'recipients_event.dart';
import 'recipients_state.dart';

class RecipientsBloc extends Bloc<RecipientsEvent, RecipientsState> {
  final GetRecipients getRecipients;
  final GetRecipient getRecipient;
  final CreateRecipient createRecipient;
  final usecases.UpdateRecipient updateRecipient;
  final usecases.DeleteRecipient deleteRecipient;
  
  RecipientsBloc({
    required this.getRecipients,
    required this.getRecipient,
    required this.createRecipient,
    required this.updateRecipient,
    required this.deleteRecipient,
  }) : super(RecipientsInitial()) {
    on<FetchRecipients>(_onFetchRecipients);
    on<FetchRecipient>(_onFetchRecipient);
    on<AddRecipientEvent>(_onAddRecipient);
    on<UpdateRecipientEvent>(_onUpdateRecipient);
    on<DeleteRecipientEvent>(_onDeleteRecipient);
  }
  
  Future<void> _onFetchRecipients(
    FetchRecipients event,
    Emitter<RecipientsState> emit,
  ) async {
    emit(RecipientsLoading());
    try {
      final recipients = await getRecipients();
      emit(RecipientsLoaded(recipients: recipients));
    } catch (e) {
      emit(RecipientsError(message: e.toString()));
    }
  }
  
  Future<void> _onFetchRecipient(
    FetchRecipient event,
    Emitter<RecipientsState> emit,
  ) async {
    emit(RecipientsLoading());
    try {
      final recipient = await getRecipient(event.id);
      emit(RecipientLoaded(recipient: recipient));
    } catch (e) {
      emit(RecipientsError(message: e.toString()));
    }
  }
  
  Future<void> _onAddRecipient(
    AddRecipientEvent event,
    Emitter<RecipientsState> emit,
  ) async {
    emit(RecipientsLoading());
    try {
      final recipient = await createRecipient(event.recipient);
      emit(RecipientSaved(recipient: recipient));
    } catch (e) {
      emit(RecipientsError(message: e.toString()));
    }
  }
  
  Future<void> _onUpdateRecipient(
    UpdateRecipientEvent event,
    Emitter<RecipientsState> emit,
  ) async {
    emit(RecipientsLoading());
    try {
      final recipient = await updateRecipient(event.recipient);
      emit(RecipientSaved(recipient: recipient));
    } catch (e) {
      emit(RecipientsError(message: e.toString()));
    }
  }
  
  Future<void> _onDeleteRecipient(
    DeleteRecipientEvent event,
    Emitter<RecipientsState> emit,
  ) async {
    emit(RecipientsLoading());
    try {
      await deleteRecipient(event.id);
      emit(RecipientDeleted());
      
      // Ricarica la lista dopo l'eliminazione
      add(FetchRecipients());
    } catch (e) {
      emit(RecipientsError(message: e.toString()));
    }
  }
}