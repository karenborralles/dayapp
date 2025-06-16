import 'dart:convert';
import 'package:dayapp/core/constants.dart';
import 'package:http/http.dart' as http;
import '../models/history_model.dart';

class HistoryRemoteDataSource {
  Future<List<HistoryModel>> getTodayHistory() async {
    final response = await http.get(Uri.parse(ApiConstants.baseUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final events = data['data']['Events'] as List;
      return events.map((e) => HistoryModel.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar eventos');
    }
  }
}