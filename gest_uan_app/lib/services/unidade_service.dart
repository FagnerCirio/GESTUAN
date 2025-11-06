// lib/services/unidade_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/unidade_model.dart';

class UnidadeService {
  final String _baseUrl =
      'http://localhost:8080/unidades'; // Ajuste o IP se necessário

  Future<List<Unidade>> getUnidades() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      List<Unidade> unidades = body
          .map((dynamic item) => Unidade.fromJson(item))
          .toList();
      return unidades;
    } else {
      throw Exception('Falha ao carregar unidades.');
    }
  }

  Future<Unidade> createUnidade(Unidade unidade, {String? empresaCnpj}) async {
    final Map<String, dynamic> requestBody = {
      'nome': unidade.nome,
      'endereco': unidade.endereco,
      'cnpj': unidade.cnpj, // NOVO CAMPO
    };

    if (empresaCnpj != null) {
      requestBody['empresa'] = {'cnpj': empresaCnpj};
    }

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Unidade.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao criar unidade: ${response.body}');
    }
  }
}
