import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giftai/blocs/history/history_event.dart';
import 'package:giftai/blocs/history/history_state.dart';
import 'package:giftai/repositories/history_repository.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final HistoryRepository _historyRepository;

  HistoryBloc({required HistoryRepository historyRepository})
      : _historyRepository = historyRepository,
        super(HistoryInitial()) {
    on<HistoryFetchRequested>(_onHistoryFetchRequested);
    on<HistoryDetailRequested>(_onHistoryDetailRequested);
  }

  Future<void> _onHistoryFetchRequested(
    HistoryFetchRequested event,
    Emitter<HistoryState> emit,
  ) async {
    emit(HistoryLoading());
    try {
      final histories = await _historyRepository.getHistory();
      emit(HistoryLoadSuccess(histories: histories));
    } catch (e) {
      emit(HistoryLoadFailure(message: e.toString()));
    }
  }

  Future<void> _onHistoryDetailRequested(
    HistoryDetailRequested event,
    Emitter<HistoryState> emit,
  ) async {
    emit(HistoryLoading());
    try {
      final history = await _historyRepository.getHistoryDetail(event.id);
      if (history != null) {
        emit(HistoryDetailSuccess(history: history));
      } else {
        emit(const HistoryDetailFailure(message: 'Cronologia non trovata.'));
      }
    } catch (e) {
      emit(HistoryDetailFailure(message: e.toString()));
    }
  }
}