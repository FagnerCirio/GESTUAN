// lib/services/unidade_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/unidade_model.dart';

class UnidadeService {
  // 1. CORREÇÃO DA URL: Usa '/api/unidades' para evitar o erro 404
  final String _baseUrl = 'http://localhost:8080/api/unidades';

  // Buscar Lista de Unidades
  Future<List<Unidade>> getUnidades() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        List<Unidade> unidades =
            body.map((dynamic item) => Unidade.fromJson(item)).toList();
        return unidades;
      } else {
        throw Exception('Falha ao carregar unidades: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

// Cadastrar Unidade (com vínculo de empresa)
  Future<void> cadastrarUnidade(Unidade unidade) async {
    final Map<String, dynamic> requestBody = {
      'nome': unidade.nome,
      'endereco': unidade.endereco,
      'cnpj': unidade.cnpj,
    };

    // 2. CORREÇÃO DO PAYLOAD: Envia o CNPJ (resolve o erro 'undefined_getter: id' no Dart)
    if (unidade.empresa != null && unidade.empresa!.cnpj != null) {
      // O backend Java agora faz a busca por este CNPJ.
      requestBody['empresa'] = {'cnpj': unidade.empresa!.cnpj};
    } else {
      throw Exception(
          'CNPJ da Empresa é obrigatório para cadastrar a unidade.');
    }

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Removido o 'print' para evitar aviso do linter
      return;
    } else {
      throw Exception(
          'Falha ao criar unidade. Status: ${response.statusCode}. Erro: ${response.body}');
    }
  }

  // --- DELETAR UNIDADE ---
  Future<void> deletarUnidade(int id) async {
    try {
      final response = await http.delete(Uri.parse('$_baseUrl/$id'));
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Falha ao deletar unidade: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro ao deletar unidade: $e');
    }
  }
}
