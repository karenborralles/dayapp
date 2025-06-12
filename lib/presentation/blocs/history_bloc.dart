import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dayapp/presentation/blocs/history_event.dart';
import 'package:dayapp/presentation/blocs/history_state.dart';
import 'package:dayapp/domain/usecases/get_today_events.dart';

class HistoryBloc extends Bloc<HistoryBlocEvent, HistoryState> {
  final GetTodayEvents getTodayEvents;

  HistoryBloc(this.getTodayEvents) : super(HistoryInitial()) {
    on<LoadTodayEvents>((event, emit) async {
      emit(HistoryLoading());
      try {
        final events = await getTodayEvents();
        emit(HistoryLoaded(events));
      } catch (e) {
        emit(HistoryError('Error al cargar eventos históricos'));
      }
    });
  }
}