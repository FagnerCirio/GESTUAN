// lib/utils/pdf_generator.dart
import 'dart:io';
import 'dart:typed_data'; // NOVO: Necessário para retornar os bytes
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart' show TextEditingController;
import 'package:flutter/foundation.dart'
    show kIsWeb; // NOVO: Import para detectar a plataforma
import '../models/checklist_item_model.dart';

// --- NOVO: FUNÇÃO PRINCIPAL QUE RETORNA OS BYTES DO PDF (Universal) ---
// Toda a lógica de construção do PDF é movida para cá.
Future<Uint8List> generateChecklistPdfBytes({
  required String checklistTitle,
  required Map<String, List<ChecklistItem>> groupedItems,
  required Map<int, String> respostas,
  required Map<int, TextEditingController> observacoesControllers,
  required double score,
  required String nomeUsuario,
  required String nomeUnidade,
}) async {
  final pdf = pw.Document();

  // Cria a página
  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(24),
      build: (pw.Context context) {
        return [
          // --- CABEÇALHO ---
          _buildHeader(checklistTitle, nomeUnidade, nomeUsuario, score),
          pw.SizedBox(height: 20),

          // --- CONTEÚDO (Itera sobre as seções) ---
          ...groupedItems.entries.map((entry) {
            final section = entry.key;
            final items = entry.value;

            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Título da Seção
                pw.Container(
                  width: double.infinity,
                  color: PdfColors.grey300,
                  padding: const pw.EdgeInsets.all(5),
                  margin: const pw.EdgeInsets.only(top: 10, bottom: 5),
                  child: pw.Text(
                    section.toUpperCase(),
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
                // Lista de Itens da Seção
                ...items.map((item) {
                  final itemId = item.id.toInt();
                  final resposta = respostas[itemId] ?? 'N/A';
                  final controller = observacoesControllers[itemId];
                  final observacao = controller?.text ?? '';

                  PdfColor corResposta = PdfColors.black;
                  if (resposta == 'C') corResposta = PdfColors.green700;
                  if (resposta == 'NC') corResposta = PdfColors.red700;

                  return pw.Container(
                    margin: const pw.EdgeInsets.only(bottom: 8),
                    padding: const pw.EdgeInsets.only(bottom: 8),
                    decoration: const pw.BoxDecoration(
                      border: pw.Border(
                          bottom: pw.BorderSide(
                              color: PdfColors.grey300, width: 0.5)),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        // Pergunta
                        pw.Text(
                          item.itemAvaliado ?? 'Item sem descrição',
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                        pw.SizedBox(height: 4),

                        // Linha de Resposta
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              "Resposta: $resposta",
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  color: corResposta,
                                  fontSize: 10),
                            ),
                          ],
                        ),

                        // Se tiver observação, mostra embaixo
                        if (observacao.isNotEmpty)
                          pw.Padding(
                            padding: const pw.EdgeInsets.only(top: 2),
                            child: pw.Text(
                              "Obs: $observacao",
                              style: pw.TextStyle(
                                  fontSize: 9,
                                  fontStyle: pw.FontStyle.italic,
                                  color: PdfColors.grey700),
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            );
          }).toList(),
        ];
      },
    ),
  );

  return await pdf.save(); // Retorna os bytes puros
}
// --- FIM DA NOVA FUNÇÃO ---

// --- FUNÇÃO ANTIGA (Agora adaptada para tratar apenas a SALVAMENTO/MOBILE/DESKTOP) ---
Future<String> generateChecklistPdf({
  required String checklistTitle,
  required Map<String, List<ChecklistItem>> groupedItems,
  required Map<int, String> respostas,
  required Map<int, TextEditingController> observacoesControllers,
  required double score,
  required String nomeUsuario,
  required String nomeUnidade,
}) async {
  if (kIsWeb) {
    // Se for Web, lançamos um erro, pois a lógica de salvamento local não se aplica.
    // A tela de checklist deve chamar generateChecklistPdfBytes diretamente.
    throw UnsupportedError(
        'O salvamento direto em arquivo não é suportado na Web. Use generateChecklistPdfBytes().');
  }

  // GERA OS BYTES USANDO A NOVA FUNÇÃO
  final bytes = await generateChecklistPdfBytes(
    checklistTitle: checklistTitle,
    groupedItems: groupedItems,
    respostas: respostas,
    observacoesControllers: observacoesControllers,
    score: score,
    nomeUsuario: nomeUsuario,
    nomeUnidade: nomeUnidade,
  );

  // Lógica de salvamento (funciona apenas em Mobile/Desktop)
  final output = await getApplicationDocumentsDirectory();
  final fileName = 'checklist_${DateTime.now().millisecondsSinceEpoch}.pdf';
  final file = File("${output.path}/$fileName");
  await file.writeAsBytes(bytes); // Salva os bytes

  return file.path;
}

// Função auxiliar _buildHeader (mantida inalterada)
pw.Widget _buildHeader(
    String title, String unidade, String usuario, double score) {
  // ... (Conteúdo da função _buildHeader é idêntico ao original)
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Center(
        child: pw.Text(
          "RELATÓRIO DE AUDITORIA - GEST-UAN",
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16),
        ),
      ),
      pw.SizedBox(height: 10),
      pw.Divider(),
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text("Checklist: $title", style: pw.TextStyle(fontSize: 12)),
          pw.Text("Data: ${DateTime.now().toString().split(' ')[0]}",
              style: const pw.TextStyle(fontSize: 10)),
        ],
      ),
      pw.SizedBox(height: 5),
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text("Unidade: $unidade", style: const pw.TextStyle(fontSize: 10)),
          pw.Text("Responsável: $usuario",
              style: const pw.TextStyle(fontSize: 10)),
        ],
      ),
      pw.SizedBox(height: 10),
      pw.Container(
        width: double.infinity,
        padding: const pw.EdgeInsets.all(8),
        decoration: pw.BoxDecoration(
          color: score >= 70 ? PdfColors.green100 : PdfColors.red100,
          border: pw.Border.all(
              color: score >= 70 ? PdfColors.green : PdfColors.red),
        ),
        child: pw.Center(
          child: pw.Text(
            "PONTUAÇÃO FINAL: ${score.toStringAsFixed(1)}%",
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 14,
              color: score >= 70 ? PdfColors.green900 : PdfColors.red900,
            ),
          ),
        ),
      ),
      pw.Divider(),
    ],
  );
}
