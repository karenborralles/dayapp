import 'package:dayapp/presentation/pages/detail_page.dart';
import 'package:dayapp/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/history_event.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/details/:year',
      builder: (context, state) {
        final year = state.pathParameters['year']!;
        final extra = state.extra as List<HistoryEvent>;
        return DetailPage(year: year, events: extra);
      },
    ),
  ],
);