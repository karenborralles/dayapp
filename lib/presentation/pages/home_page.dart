import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/history_event.dart' as entity;
import '../blocs/history_bloc.dart';
import '../blocs/history_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchYear = '';

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('d MMMM yyyy', 'es_MX').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Un día como hoy'),
        centerTitle: true,
        elevation: 2,
      ),
      body: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HistoryLoaded) {
            final filtered = state.events
                .where((e) => searchYear.isEmpty || e.year.contains(searchYear))
                .toList();

            final grouped = <String, List<entity.HistoryEvent>>{};
            for (var e in filtered) {
              try {
                if (e.year.contains('BC')) continue;
                final parsed = int.parse(e.year);
                final century = '${(parsed ~/ 100 + 1)}00s';
                grouped.putIfAbsent(century, () => []).add(e);
              } catch (_) {
                continue;
              }
            }

            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.teal.shade100, Colors.white],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black12)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '📅 Hoy es $today',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        decoration: InputDecoration(
                          hintText: '🔍 Buscar por año...',
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: const Icon(Icons.search),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) => setState(() => searchYear = value),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: AnimationLimiter(
                    child: ListView.builder(
                      itemCount: grouped.keys.length,
                      padding: const EdgeInsets.only(bottom: 16),
                      itemBuilder: (context, i) {
                        final section = grouped.keys.elementAt(i);
                        final items = grouped[section]!;

                        return AnimationConfiguration.staggeredList(
                          position: i,
                          duration: const Duration(milliseconds: 400),
                          child: SlideAnimation(
                            horizontalOffset: 50.0,
                            child: FadeInAnimation(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 6),
                                      child: Text(
                                        section,
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.teal,
                                        ),
                                      ),
                                    ),
                                    ...items.map(
                                      (e) => GestureDetector(
                                        onTap: () {
                                          context.push('/details/${e.year}', extra: filtered);
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(vertical: 6),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(14),
                                            border: Border.all(color: Colors.teal.shade100, width: 1.3),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 4,
                                                offset: const Offset(1, 2),
                                              ),
                                            ],
                                          ),
                                          child: ListTile(
                                            leading: const Icon(Icons.access_time_filled_rounded,
                                                color: Colors.teal),
                                            title: Text('Año ${e.year}',
                                                style: const TextStyle(fontWeight: FontWeight.w500)),
                                            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          } else if (state is HistoryError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),

      // 🔽 FAB con evento aleatorio
      floatingActionButton: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoaded && state.events.isNotEmpty) {
            return FloatingActionButton.extended(
              onPressed: () {
                final all = state.events;
                final randomEvent = (all..shuffle()).first;

                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    title: const Text('🎲 Evento aleatorio'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('📅 Año: ${randomEvent.year}',
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Text(randomEvent.text),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cerrar'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop(); // Cierra el modal
                          context.push('/details/${randomEvent.year}', extra: all);
                        },
                        icon: const Icon(Icons.open_in_new),
                        label: const Text('Ver más'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.casino),
              label: const Text('Evento aleatorio'),
              backgroundColor: Colors.teal,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}