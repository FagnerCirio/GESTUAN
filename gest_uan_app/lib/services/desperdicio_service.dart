// lib/services/desperdicio_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/desperdicio_model.dart';
import '../models/desperdicio_stats_model.dart'; // Importa o modelo corrigido
import 'package:intl/intl.dart';

class DesperdicioService {
  // URL base agora aponta para /api
  final String _baseUrl =
      'http://localhost:8080/api'; // Ajuste o IP se necessário

  // Recebe o ID da unidade
  Future<List<Desperdicio>> getRegistros(int unidadeId) async {
    final response =
        await http.get(Uri.parse('$_baseUrl/unidades/$unidadeId/desperdicio'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      return body.map((dynamic item) => Desperdicio.fromJson(item)).toList();
    } else {
      throw Exception('Falha ao carregar registros de desperdício.');
    }
  }

  // Recebe o ID da unidade e o registro
  Future<Desperdicio> createRegistro(
      int unidadeId, Desperdicio registro) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/unidades/$unidadeId/desperdicio'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'data': DateFormat('yyyy-MM-dd').format(registro.data),
        'tipo': registro.tipo,
        'peso': registro.peso,
        'destino': registro.destino,
        'numeroRefeicoes': registro.numeroRefeicoes,
        'unidade': {'id': unidadeId}, // Envia o ID da unidade para associação
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Desperdicio.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao criar registro.');
    }
  }

  // Método para buscar as estatísticas (Gráfico)
  Future<List<DesperdicioStats>> getStats(int unidadeId) async {
    final response = await http
        .get(Uri.parse('$_baseUrl/unidades/$unidadeId/desperdicio/stats'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      // ESTA LINHA AGORA VAI FUNCIONAR
      return body
          .map((dynamic item) => DesperdicioStats.fromJson(item))
          .toList();
    } else {
      throw Exception('Falha ao carregar estatísticas.');
    }
  }
}
