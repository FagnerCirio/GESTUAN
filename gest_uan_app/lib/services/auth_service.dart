// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/usuario_model.dart'; // IMPORTA O NOVO MODELO

class AuthService {
  final String _baseUrl =
      'http://localhost:8080/auth'; // Ajuste o IP se necessário

  // AGORA O MÉTODO RETORNA UM Future<Usuario>
  Future<Usuario> login(String crn, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'crn': crn, 'senha': password}),
    );

    if (response.statusCode == 200) {
      // Decodifica o JSON e cria um objeto Usuario
      return Usuario.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Falha no login: ${response.body}');
    }
  }
}
