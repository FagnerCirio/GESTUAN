// lib/utils/pdf_generator.dart
import 'dart:io'; // Para File
import 'package:flutter/material.dart'; // Para TextEditingController
import 'package:path_provider/path_provider.dart'; // Para diretórios
import 'package:pdf/pdf.dart'; // Cores e tamanhos do PDF
import 'package:pdf/widgets.dart' as pw; // Widgets do PDF
import '../models/checklist_item_model.dart';
import 'package:intl/intl.dart'; // Para formatar data

// Função principal que gera o PDF
Future<String> generateChecklistPdf({
  required String checklistTitle,
  required Map<String, List<ChecklistItem>> groupedItems,
  required Map<int, String> respostas,
  required Map<int, TextEditingController> observacoesControllers,
  required double score,
  required String nomeUsuario,
  required String nomeUnidade,
}) async {
  final pdf = pw.Document(); // Cria um novo documento PDF

  // --- Estilos de Texto ---
  // Usando fontes padrão por enquanto. Para fontes customizadas (e melhor suporte a acentos):
  // 1. Baixe os arquivos .ttf (ex: NotoSans)
  // 2. Crie a pasta 'assets/fonts' no seu projeto
  // 3. Adicione a pasta ao pubspec.yaml
  // 4. Descomente e ajuste as linhas de carregamento de fontes abaixo.
  /*
  final fontData = await rootBundle.load("assets/fonts/NotoSans-Regular.ttf");
  final boldFontData = await rootBundle.load("assets/fonts/NotoSans-Bold.ttf");
  final ttf = pw.Font.ttf(fontData.buffer.asByteData());
  final boldTtf = pw.Font.ttf(boldFontData.buffer.asByteData());
  final baseStyle = pw.TextStyle(font: ttf, fontSize: 10);
  final boldStyle = pw.TextStyle(font: boldTtf, fontSize: 10);
  final headerStyle = pw.TextStyle(font: boldTtf, fontSize: 11, color: PdfColors.white);
  final pageNumStyle = pw.TextStyle(font: ttf, fontSize: 8, color: PdfColors.grey);
  */

  // Usando fontes padrão:
  final baseStyle = pw.Theme.of(pw.Context(document: pdf.document))
      .defaultTextStyle
      .copyWith(fontSize: 10);
  final boldStyle = baseStyle.copyWith(fontWeight: pw.FontWeight.bold);
  final headerStyle = boldStyle.copyWith(fontSize: 11, color: PdfColors.white);
  final pageNumStyle = baseStyle.copyWith(fontSize: 8, color: PdfColors.grey);

  // --- Funções Auxiliares para construir partes do PDF ---

  // Cria o cabeçalho de cada seção (ex: "ESTRUTURA")
  pw.Widget buildSectionHeader(String title) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 15, bottom: 5),
      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      decoration: const pw.BoxDecoration(color: PdfColors.teal700),
      child: pw.Text(title, style: headerStyle),
    );
  }

  // Cria a linha para cada item do checklist no PDF
  pw.Widget buildItemRow(ChecklistItem item, int itemId) {
    final resposta = respostas[itemId] ?? 'N/R'; // 'N/R' se não respondido
    final observacao = observacoesControllers[itemId]?.text ?? '';
    // Destaca a linha se a resposta for "Não Conforme"
    final PdfColor rowColor =
        resposta == 'NC' ? PdfColors.red100 : PdfColors.white;

    return pw.Container(
        color: rowColor,
        padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 6),
        child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Texto da pergunta
              pw.Text(item.itemAvaliado, style: baseStyle),
              pw.SizedBox(height: 4), // Espaçamento
              // Linha com a Resposta e a Observação
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment
                      .spaceBetween, // Espaça entre resposta e obs
                  crossAxisAlignment:
                      pw.CrossAxisAlignment.start, // Alinha no topo
                  children: [
                    // Resposta (com cor)
                    pw.Text('Resp: $resposta',
                        style: boldStyle.copyWith(
                            fontSize: 9,
                            // Cor baseada na resposta
                            color: resposta == 'C'
                                ? PdfColors.green700
                                : (resposta == 'NC'
                                    ? PdfColors.red700
                                    : PdfColors.grey600))),
                    // Observação (só mostra se não estiver vazia)
                    if (observacao.isNotEmpty)
                      // Usa Flexible para quebrar linha se a observação for longa
                      pw.Flexible(
                          child: pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 10),
                        child: pw.Text('Obs: $observacao',
                            style: baseStyle.copyWith(
                                fontStyle: pw.FontStyle.italic, fontSize: 9),
                            maxLines: 4),
                      ))
                  ])
            ]));
  }

  // --- Construção das Páginas do PDF ---
  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4, // Tamanho da página
      margin: const pw.EdgeInsets.all(30), // Margens
      // Cabeçalho de cada página (número da página)
      header: (pw.Context context) {
        if (context.pageNumber == 1)
          return pw.SizedBox.shrink(); // Não mostra na primeira página
        return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(bottom: 10.0),
            child: pw.Text(
                'Página ${context.pageNumber} / ${context.pagesCount}',
                style: pageNumStyle));
      },
      // Rodapé de cada página (data de geração)
      footer: (pw.Context context) {
        return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 10.0),
            child: pw.Text(
                'Gerado em: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
                style: pageNumStyle));
      },
      // Função que constrói o conteúdo principal do PDF
      build: (pw.Context context) {
        List<pw.Widget> content = []; // Lista para adicionar os widgets do PDF

        // 1. Título e Informações Iniciais
        content.add(pw.Header(
          level: 0, // Título principal
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(checklistTitle,
                  style:
                      boldStyle.copyWith(fontSize: 18)), // Título do Checklist
              pw.Text(DateFormat('dd/MM/yyyy').format(DateTime.now()),
                  style: baseStyle), // Data
            ],
          ),
        ));
        content.add(pw.Text('Unidade: $nomeUnidade',
            style: boldStyle)); // Nome da Unidade
        content.add(pw.Text('Responsável: $nomeUsuario',
            style: boldStyle)); // Nome do Usuário
        content.add(pw.Divider(height: 25, thickness: 1)); // Linha divisória

        // 2. Resumo da Pontuação
        content.add(pw.Paragraph(
          text:
              'Pontuação Final: ${score.toStringAsFixed(1)}%', // Score formatado
          style: boldStyle.copyWith(
              fontSize: 12,
              // Cor do score baseada no valor
              color: score >= 80
                  ? PdfColors.green700
                  : (score >= 50 ? PdfColors.orange700 : PdfColors.red700)),
        ));
        content.add(pw.SizedBox(height: 15)); // Espaçamento

        // 3. Loop pelas Seções e Itens do Checklist
        final sections = groupedItems.keys.toList()
          ..sort(); // Pega e ordena as seções
        for (var section in sections) {
          content.add(
              buildSectionHeader(section)); // Adiciona o cabeçalho da seção
          final itemsInSection =
              groupedItems[section]!; // Pega os itens da seção
          for (var item in itemsInSection) {
            content.add(buildItemRow(
                item, item.id.toInt())); // Adiciona a linha do item
            content.add(pw.Divider(
                height: 1, color: PdfColors.grey300)); // Linha fina entre itens
          }
        }

        return content; // Retorna a lista de widgets para serem desenhados na página
      },
    ),
  );

  // --- Salvar o arquivo PDF no dispositivo ---
  try {
    // Pega o diretório temporário do aplicativo (mais seguro para salvar)
    final outputDir = await getTemporaryDirectory();
    // Cria o nome do arquivo (ex: checklist_Auditoria_Qualidade_20251029_203000.pdf)
    final fileName =
        'checklist_${checklistTitle.replaceAll(' ', '_')}_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf';
    final outputFile = File('${outputDir.path}/$fileName');
    // Salva os bytes do PDF no arquivo
    await outputFile.writeAsBytes(await pdf.save());

    print('PDF salvo em: ${outputFile.path}'); // Log para debug
    return outputFile.path; // Retorna o caminho onde o arquivo foi salvo
  } catch (e) {
    print("Erro ao salvar PDF: $e");
    rethrow; // Re-lança o erro para a tela que chamou
  }
}
