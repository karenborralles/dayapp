import '../../domain/entities/history_event.dart';

class HistoryModel extends HistoryEvent {
  HistoryModel({required super.year, required super.text});

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      year: json['year'] ?? '',
      text: json['text'] ?? '',
    );
  }
}