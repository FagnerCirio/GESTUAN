// lib/models/usuario_model.dart

class Usuario {
  final String crn;
  final String nome;
  final String email;

  Usuario({required this.crn, required this.nome, required this.email});

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(crn: json['crn'], nome: json['nome'], email: json['email']);
  }
}
