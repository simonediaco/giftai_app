import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giftai/blocs/recipient/recipient_event.dart';
import 'package:giftai/blocs/recipient/recipient_state.dart';
import 'package:giftai/repositories/recipient_repository.dart';

class RecipientBloc extends Bloc<RecipientEvent, RecipientState> {
  final RecipientRepository _recipientRepository;

  RecipientBloc({required RecipientRepository recipientRepository})
      : _recipientRepository = recipientRepository,
        super(RecipientInitial()) {
    on<RecipientFetchRequested>(_onRecipientFetchRequested);
    on<RecipientDetailRequested>(_onRecipientDetailRequested);
    on<RecipientCreateRequested>(_onRecipientCreateRequested);
    on<RecipientUpdateRequested>(_onRecipientUpdateRequested);
    on<RecipientDeleteRequested>(_onRecipientDeleteRequested);
  }

  Future<void> _onRecipientFetchRequested(
    RecipientFetchRequested event,
    Emitter<RecipientState> emit,
  ) async {
    emit(RecipientLoading());
    try {
      final recipients = await _recipientRepository.getRecipients();
      emit(RecipientLoadSuccess(recipients: recipients));
    } catch (e) {
      emit(RecipientLoadFailure(message: e.toString()));
    }
  }

  Future<void> _onRecipientDetailRequested(
    RecipientDetailRequested event,
    Emitter<RecipientState> emit,
  ) async {
    emit(RecipientLoading());
    try {
      final recipient = await _recipientRepository.getRecipient(event.id);
      if (recipient != null) {
        emit(RecipientDetailSuccess(recipient: recipient));
      } else {
        emit(const RecipientDetailFailure(message: 'Destinatario non trovato.'));
      }
    } catch (e) {
      emit(RecipientDetailFailure(message: e.toString()));
    }
  }

  Future<void> _onRecipientCreateRequested(
    RecipientCreateRequested event,
    Emitter<RecipientState> emit,
  ) async {
    emit(RecipientLoading());
    try {
      final recipient = await _recipientRepository.createRecipient(event.recipient);
      if (recipient != null) {
        emit(RecipientCreateSuccess(recipient: recipient));
      } else {
        emit(const RecipientCreateFailure(message: 'Impossibile creare il destinatario.'));
      }
    } catch (e) {
      emit(RecipientCreateFailure(message: e.toString()));
    }
  }

  Future<void> _onRecipientUpdateRequested(
    RecipientUpdateRequested event,
    Emitter<RecipientState> emit,
  ) async {
    emit(RecipientLoading());
    try {
      final recipient = await _recipientRepository.updateRecipient(event.recipient);
      if (recipient != null) {
        emit(RecipientUpdateSuccess(recipient: recipient));
      } else {
        emit(const RecipientUpdateFailure(message: 'Impossibile aggiornare il destinatario.'));
      }
    } catch (e) {
      emit(RecipientUpdateFailure(message: e.toString()));
    }
  }

  Future<void> _onRecipientDeleteRequested(
    RecipientDeleteRequested event,
    Emitter<RecipientState> emit,
  ) async {
    emit(RecipientLoading());
    try {
      final success = await _recipientRepository.deleteRecipient(event.id);
      if (success) {
        emit(RecipientDeleteSuccess());
      } else {
        emit(const RecipientDeleteFailure(message: 'Impossibile eliminare il destinatario.'));
      }
    } catch (e) {
      emit(RecipientDeleteFailure(message: e.toString()));
    }
  }
}