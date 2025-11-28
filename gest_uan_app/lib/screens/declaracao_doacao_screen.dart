import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:typed_data';
import '../utils/declaracao_pdf_generator.dart';

class DeclaracaoDoacaoScreen extends StatefulWidget {
  const DeclaracaoDoacaoScreen({Key? key}) : super(key: key);

  @override
  State<DeclaracaoDoacaoScreen> createState() => _DeclaracaoDoacaoScreenState();
}

class _DeclaracaoDoacaoScreenState extends State<DeclaracaoDoacaoScreen> {
  final _formKey = GlobalKey<FormState>();

  // --- DOADOR ---
  final doadorNomeController = TextEditingController();
  final doadorCpfController = TextEditingController();
  final doadorEnderecoController = TextEditingController();
  final doadorTelefoneController = TextEditingController();
  final doadorEmailController = TextEditingController();

  // --- DONATÁRIO ---
  final donatarioNomeController = TextEditingController();
  final donatarioCpfController = TextEditingController();
  final donatarioEnderecoController = TextEditingController();
  final donatarioMunicipioController = TextEditingController();
  final donatarioTelefoneController = TextEditingController();
  final donatarioEmailController = TextEditingController();

  // --- DOAÇÃO ---
  final tipoResiduoController = TextEditingController();
  final quantidadeController = TextEditingController();

  bool _isExporting = false;

  @override
  void dispose() {
    doadorNomeController.dispose();
    doadorCpfController.dispose();
    doadorEnderecoController.dispose();
    doadorTelefoneController.dispose();
    doadorEmailController.dispose();

    donatarioNomeController.dispose();
    donatarioCpfController.dispose();
    donatarioEnderecoController.dispose();
    donatarioMunicipioController.dispose();
    donatarioTelefoneController.dispose();
    donatarioEmailController.dispose();

    tipoResiduoController.dispose();
    quantidadeController.dispose();
    super.dispose();
  }

  // ================================================================
  // ✅ GERAR PDF DA DECLARAÇÃO (WEB + MOBILE)
  // ================================================================
  void _exportarDeclaracao() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isExporting) return;

    setState(() => _isExporting = true);

    try {
      Uint8List pdfBytes = await gerarDeclaracaoPdf(
        doadorNome: doadorNomeController.text,
        doadorCpf: doadorCpfController.text,
        doadorEndereco: doadorEnderecoController.text,
        doadorTelefone: doadorTelefoneController.text,
        doadorEmail: doadorEmailController.text,
        donatarioNome: donatarioNomeController.text,
        donatarioCpf: donatarioCpfController.text,
        donatarioEndereco: donatarioEnderecoController.text,
        donatarioMunicipio: donatarioMunicipioController.text,
        donatarioTelefone: donatarioTelefoneController.text,
        donatarioEmail: donatarioEmailController.text,
        tipoResiduo: tipoResiduoController.text,
        quantidade: quantidadeController.text,
      );

      if (kIsWeb) {
        final blob = html.Blob([pdfBytes], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);

        html.AnchorElement(href: url)
          ..setAttribute("download", "declaracao_doacao.pdf")
          ..click();

        html.Url.revokeObjectUrl(url);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PDF gerado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao gerar PDF: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  // ================================================================
  // COMPONENTES DE TELA
  // ================================================================
  Widget _titulo(String texto) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        texto,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _campo(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? 'Campo obrigatório' : null,
      ),
    );
  }

  // ================================================================
  // TELA
  // ================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Declaração de Doação'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _titulo('DOADOR'),
              _campo('Nome / Razão Social', doadorNomeController),
              _campo('CPF / CNPJ', doadorCpfController),
              _campo('Endereço', doadorEnderecoController),
              _campo('Telefone', doadorTelefoneController),
              _campo('E-mail', doadorEmailController),
              _titulo('DONATÁRIO (AGRICULTOR)'),
              _campo('Nome', donatarioNomeController),
              _campo('CPF', donatarioCpfController),
              _campo(
                  'Endereço da Propriedade Rural', donatarioEnderecoController),
              _campo('Município', donatarioMunicipioController),
              _campo('Telefone', donatarioTelefoneController),
              _campo('E-mail', donatarioEmailController),
              _titulo('DADOS DA DOAÇÃO'),
              _campo('Tipo de Resíduo Doado', tipoResiduoController),
              _campo('Quantidade Aproximada', quantidadeController),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  icon: _isExporting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.picture_as_pdf),
                  label: Text(
                      _isExporting ? 'Gerando...' : 'Gerar Declaração em PDF'),
                  onPressed: _isExporting ? null : _exportarDeclaracao,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
