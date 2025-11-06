// lib/services/checklist_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/checklist_item_model.dart';

class ChecklistService {
  final String _baseUrl = 'http://localhost:8080/api/checklists'; // Ajuste o IP

  // Método agora recebe o tipo de checklist que queremos buscar
  Future<List<ChecklistItem>> getChecklistItems(String checklistType) async {
    // Adiciona o parâmetro 'type' na URL
    final response = await http.get(
      Uri.parse('$_baseUrl/items?type=$checklistType'),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      List<ChecklistItem> items = body
          .map((dynamic item) => ChecklistItem.fromJson(item))
          .toList();
      return items;
    } else {
      throw Exception('Falha ao carregar os itens do checklist');
    }
  }
}
