import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<Uint8List> gerarDeclaracaoPdf({
  required String doadorNome,
  required String doadorCpf,
  required String doadorEndereco,
  required String doadorTelefone,
  required String doadorEmail,
  required String donatarioNome,
  required String donatarioCpf,
  required String donatarioEndereco,
  required String donatarioMunicipio,
  required String donatarioTelefone,
  required String donatarioEmail,
  required String tipoResiduo,
  required String quantidade,
}) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(40),
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(
              child: pw.Text(
                'DECLARAÇÃO DE DOAÇÃO DE RESÍDUOS ORGÂNICOS',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 24),
            pw.Text('DOADOR(A):',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            pw.Text('Nome/Razão Social: $doadorNome'),
            pw.Text('CPF/CNPJ: $doadorCpf'),
            pw.Text('Endereço: $doadorEndereco'),
            pw.Text('Telefone: $doadorTelefone   E-mail: $doadorEmail'),
            pw.SizedBox(height: 20),
            pw.Text('DONATÁRIO (AGRICULTOR):',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            pw.Text('Nome: $donatarioNome'),
            pw.Text('CPF: $donatarioCpf'),
            pw.Text('Endereço da propriedade rural: $donatarioEndereco'),
            pw.Text('Município: $donatarioMunicipio'),
            pw.Text('Telefone: $donatarioTelefone   E-mail: $donatarioEmail'),
            pw.SizedBox(height: 24),
            pw.Text('OBJETO DA DOAÇÃO:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            pw.Text(
              'O(a) declarante acima identificado(a) declara, para os devidos fins, que está '
              'realizando a doação de resíduos orgânicos compostáveis, provenientes de '
              '(restos de alimentos, frutas, verduras, podas, etc.), em conformidade com a '
              'legislação ambiental vigente, para fins de uso agrícola, como compostagem '
              'ou adubação orgânica.',
              textAlign: pw.TextAlign.justify,
            ),
            pw.SizedBox(height: 10),
            pw.Text(
              'A doação não possui caráter comercial ou financeiro, sendo feita de forma '
              'voluntária, regular e consciente por ambas as partes. O donatário se '
              'responsabiliza pelo transporte, armazenamento e uso adequado dos resíduos '
              'orgânicos doados, isentando o doador de qualquer responsabilidade pelo uso '
              'indevido ou por eventuais danos decorrentes do mau aproveitamento dos materiais.',
              textAlign: pw.TextAlign.justify,
            ),
            pw.SizedBox(height: 20),
            pw.Text('Tipo de resíduos doados: $tipoResiduo'),
            pw.SizedBox(height: 6),
            pw.Text('Quantidade aproximada: $quantidade'),
            pw.SizedBox(height: 30),
            pw.Text('Por estarem de acordo, firmam a presente declaração.'),
            pw.SizedBox(height: 50),
            pw.Text('_______________________________'),
            pw.Text('Assinatura do(a) Doador(a)'),
            pw.Text('(Local e data)'),
            pw.SizedBox(height: 40),
            pw.Text('_______________________________'),
            pw.Text('Assinatura do(a) Donatário(a)'),
            pw.Text('(Local e data)'),
          ],
        );
      },
    ),
  );

  return pdf.save();
}
