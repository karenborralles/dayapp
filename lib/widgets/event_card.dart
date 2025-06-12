import 'package:flutter/material.dart';
import '../../../domain/entities/history_event.dart';

class EventCard extends StatelessWidget {
  final HistoryEvent event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      child: ListTile(
        title: Text(
          event.text,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Año: ${event.year}'),
        leading: const Icon(Icons.history),
      ),
    );
  }
}