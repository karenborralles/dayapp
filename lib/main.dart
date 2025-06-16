import 'package:dayapp/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart'; 
import 'package:dayapp/data/datasources/history_remote_datasource.dart';
import 'package:dayapp/data/repositories_impl/history_repository_impl.dart';
import 'package:dayapp/domain/usecases/get_today_events.dart';
import 'package:dayapp/presentation/blocs/history_bloc.dart';
import 'package:dayapp/presentation/blocs/history_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await initializeDateFormatting('es_MX', null); 

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
          scaffoldBackgroundColor: Colors.grey.shade50,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
              color: Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
            iconTheme: IconThemeData(color: Colors.teal),
          ),
        ),
      ),
    );
  }
}