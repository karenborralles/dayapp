import '../entities/history_event.dart';

abstract class HistoryRepository {
  Future<List<HistoryEvent>> getTodayEvents();
}

class GetTodayEvents {
  final HistoryRepository repository;

  GetTodayEvents(this.repository);

  Future<List<HistoryEvent>> call() => repository.getTodayEvents();
}
