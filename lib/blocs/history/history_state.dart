import 'package:equatable/equatable.dart';
import 'package:giftai/models/history_model.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object?> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoadSuccess extends HistoryState {
  final List<HistoryModel> histories;

  const HistoryLoadSuccess({required this.histories});

  @override
  List<Object> get props => [histories];
}

class HistoryLoadFailure extends HistoryState {
  final String message;

  const HistoryLoadFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class HistoryDetailSuccess extends HistoryState {
  final HistoryModel history;

  const HistoryDetailSuccess({required this.history});

  @override
  List<Object> get props => [history];
}

class HistoryDetailFailure extends HistoryState {
  final String message;

  const HistoryDetailFailure({required this.message});

  @override
  List<Object> get props => [message];
}