import 'package:dayapp/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/datasources/history_remote_datasource.dart';
import 'data/repositories_impl/history_repository_impl.dart';
import 'domain/usecases/get_today_events.dart';
import 'presentation/blocs/history_bloc.dart';
import 'presentation/blocs/history_event.dart';

void main() {
  // Instancias necesarias de capa inferior a superior
  final remoteDataSource = HistoryRemoteDataSource();
  final repository = HistoryRepositoryImpl(remoteDataSource);
  final getTodayEvents = GetTodayEvents(repository);

  runApp(MyApp(getTodayEvents: getTodayEvents));
}

class MyApp extends StatelessWidget {
  final GetTodayEvents getTodayEvents;

  const MyApp({super.key, required this.getTodayEvents});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HistoryBloc(getTodayEvents)..add(LoadTodayEvents()),
      child: MaterialApp.router(
        title: 'Un día como hoy',
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.teal,
          scaffoldBackgroundColor: Colors.white,
        ),
      ),
    );
  }
}