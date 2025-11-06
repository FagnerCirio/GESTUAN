// lib/models/empresa_model.dart

class Empresa {
  final String cnpj;
  final String nome;
  final String? endereco;

  Empresa({required this.cnpj, required this.nome, this.endereco});

  factory Empresa.fromJson(Map<String, dynamic> json) {
    return Empresa(
      cnpj: json['cnpj'],
      nome: json['nome'],
      endereco: json['endereco'],
    );
  }
}
