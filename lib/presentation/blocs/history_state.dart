import '../../../domain/entities/history_event.dart';

abstract class HistoryState {}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<HistoryEvent> events;

  HistoryLoaded(this.events);
}

class HistoryError extends HistoryState {
  final String message;

  HistoryError(this.message);
}
