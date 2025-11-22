// lib/services/empresa_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/empresa_model.dart';

class EmpresaService {
  // Padronizando com /api
  final String _baseUrl = 'http://localhost:8080/api/empresas';

  // Buscar todas as empresas
  Future<List<Empresa>> getEmpresas() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        List<Empresa> empresas =
            body.map((dynamic item) => Empresa.fromJson(item)).toList();
        return empresas;
      } else {
        throw Exception('Falha ao carregar empresas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Criar uma nova empresa
  Future<Empresa> createEmpresa(Empresa empresa) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'cnpj': empresa.cnpj,
          'nome': empresa.nome,
          'endereco': empresa.endereco,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Empresa.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Falha ao criar empresa: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro ao criar empresa: $e');
    }
  }

  // --- NOVO: DELETAR EMPRESA ---
  Future<void> deletarEmpresa(String cnpj) async {
    try {
      final response = await http.delete(Uri.parse('$_baseUrl/$cnpj'));

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Falha ao deletar empresa: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro ao deletar empresa: $e');
    }
  }
}
