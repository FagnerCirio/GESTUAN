// lib/services/checklist_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/checklist_item_model.dart';

class ChecklistService {
  // URL para BUSCAR os itens (perguntas)
  final String _baseUrl = 'http://localhost:8080/api/checklists';

  // URL para SALVAR as respostas (novo controller)
  final String _respostaUrl = 'http://localhost:8080/api/checklist-respostas';

  // Método que você já tinha, continua igual
  Future<List<ChecklistItem>> getChecklistItems(String checklistType) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/items?type=$checklistType'),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      List<ChecklistItem> items =
          body.map((dynamic item) => ChecklistItem.fromJson(item)).toList();
      return items;
    } else {
      throw Exception('Falha ao carregar os itens do checklist');
    }
  }

  // ### NOVO MÉTODO ADICIONADO ###
  // Envia o checklist preenchido para o backend
  Future<void> salvarChecklistResposta(Map<String, dynamic> payload) async {
    // Define o cabeçalho como JSON
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    // Converte o Map do Dart para uma String JSON
    final body = jsonEncode(payload);

    try {
      final response = await http.post(
        Uri.parse('$_respostaUrl/salvar'),
        headers: headers,
        body: body,
      );

      // 200 (OK) ou 201 (Created) são sucesso
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Checklist salvo com sucesso!');
      } else {
        // Se o backend der um erro (400, 500, etc.)
        print('Erro do servidor: ${response.statusCode}');
        print('Corpo da resposta: ${response.body}');
        throw Exception(
            'Falha ao salvar o checklist. Status: ${response.statusCode}');
      }
    } catch (e) {
      // Erro de rede (ex: servidor desligado)
      print('Erro de conexão ao salvar checklist: $e');
      throw Exception('Erro de conexão: $e');
    }
  }
}
