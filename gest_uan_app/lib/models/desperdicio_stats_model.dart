// lib/models/desperdicio_stats_model.dart
class DesperdicioStats {
  final String tipo;
  final double totalPeso;
  final int totalRefeicoes;

  DesperdicioStats({
    required this.tipo,
    required this.totalPeso,
    required this.totalRefeicoes,
  });

  // AQUI ESTÁ A CORREÇÃO QUE FALTAVA:
  // O construtor factory 'fromJson' que o serviço precisa
  factory DesperdicioStats.fromJson(Map<String, dynamic> json) {
    return DesperdicioStats(
      tipo: json['tipo'],
      // Converte 'num' (que pode ser int ou double) para double
      totalPeso: (json['totalPeso'] as num).toDouble(),
      // Converte 'num' (que pode ser int ou long) para int
      totalRefeicoes: (json['totalRefeicoes'] as num).toInt(),
    );
  }
}
