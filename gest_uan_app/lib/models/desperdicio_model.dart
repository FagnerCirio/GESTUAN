class Desperdicio {
  final int? id;
  final DateTime data;
  final String tipo;
  final double peso;
  final String destino;
  final int? numeroRefeicoes; // NOVO CAMPO

  Desperdicio({
    this.id,
    required this.data,
    required this.tipo,
    required this.peso,
    required this.destino,
    this.numeroRefeicoes, // ADICIONADO AO CONSTRUTOR
  });

  factory Desperdicio.fromJson(Map<String, dynamic> json) {
    return Desperdicio(
      id: json['id'],
      data: DateTime.parse(json['data']),
      tipo: json['tipo'],
      // Garantindo que o peso seja lido como double
      peso: (json['peso'] as num).toDouble(),
      destino: json['destino'],
      numeroRefeicoes: json['numeroRefeicoes'], // ADICIONADO AO FROMJSON
    );
  }
}
