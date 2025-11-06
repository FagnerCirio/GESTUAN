// lib/services/user_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http; // A CORREÇÃO ESTÁ AQUI

class UserService {
  // Para emulador Android: '10.0.2.2:8080'
  // Para Chrome na mesma máquina: 'localhost:8080'
  final String _baseUrl = 'http://localhost:8080';

  Future<void> register({
    required String crn,
    required String nome,
    required String email,
    required String senha,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/usuarios'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'crn': crn,
        'nome': nome,
        'email': email,
        'senha': senha,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Falha ao cadastrar usuário: ${response.body}');
    }
  }
}
