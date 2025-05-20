import 'package:equatable/equatable.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object?> get props => [];
}

class HistoryFetchRequested extends HistoryEvent {}

class HistoryDetailRequested extends HistoryEvent {
  final int id;

  const HistoryDetailRequested({required this.id});

  @override
  List<Object> get props => [id];
}