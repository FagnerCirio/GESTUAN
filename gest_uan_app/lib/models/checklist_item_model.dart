// lib/models/checklist_item_model.dart

class ChecklistItem {
  final int id;
  final String secao;
  final String itemAvaliado;
  final String? legislacaoDeReferencia;

  ChecklistItem({
    required this.id,
    required this.secao,
    required this.itemAvaliado,
    this.legislacaoDeReferencia,
  });

  // Factory constructor para criar um ChecklistItem a partir de um JSON
  factory ChecklistItem.fromJson(Map<String, dynamic> json) {
    return ChecklistItem(
      id: json['id'],
      secao: json['secao'],
      itemAvaliado: json['itemAvaliado'],
      legislacaoDeReferencia: json['legislacaoDeReferencia'],
    );
  }
}
