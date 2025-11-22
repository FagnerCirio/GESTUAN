// lib/models/unidade_model.dart
import 'empresa_model.dart';

class Unidade {
  final int? id;
  final String nome;
  final String? endereco;
  final String? cnpj;
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
      cnpj: json['cnpj'],
      empresa:
          json['empresa'] != null ? Empresa.fromJson(json['empresa']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'endereco': endereco,
      'cnpj': cnpj,
      // AQUI está o ajuste importante
      'empresaCnpj': empresa?.cnpj,
    };
  }
}
