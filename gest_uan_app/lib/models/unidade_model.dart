// lib/models/unidade_model.dart
import 'empresa_model.dart';

class Unidade {
  final int? id;
  final String nome;
  final String? endereco;
  final String? cnpj; // NOVO CAMPO
  final Empresa? empresa;

  Unidade({
    this.id,
    required this.nome,
    this.endereco,
    this.cnpj,
    this.empresa,
  });

  factory Unidade.fromJson(Map<String, dynamic> json) {
    return Unidade(
      id: json['id'],
      nome: json['nome'],
      endereco: json['endereco'],
      cnpj: json['cnpj'], // NOVO CAMPO
      empresa: json['empresa'] != null
          ? Empresa.fromJson(json['empresa'])
          : null,
    );
  }
}
