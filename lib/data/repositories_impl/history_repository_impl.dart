import '../../domain/entities/history_event.dart';
import '../../domain/usecases/get_today_events.dart';
import '../datasources/history_remote_datasource.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryRemoteDataSource remoteDataSource;

  HistoryRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<HistoryEvent>> getTodayEvents() {
    return remoteDataSource.getTodayHistory();
  }
}
