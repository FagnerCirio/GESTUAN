// lib/screens/add_unidade_screen.dart
import 'package:flutter/material.dart';
import '../models/empresa_model.dart';
import '../models/unidade_model.dart';
import '../services/unidade_service.dart';

class AddUnidadeScreen extends StatefulWidget {
  // 1. ADICIONAMOS O CAMPO PARA RECEBER A EMPRESA
  final Empresa empresa;

  // 2. O CONSTRUTOR AGORA EXIGE O PARÂMETRO 'empresa'
  const AddUnidadeScreen({super.key, required this.empresa});

  @override
  _AddUnidadeScreenState createState() => _AddUnidadeScreenState();
}

class _AddUnidadeScreenState extends State<AddUnidadeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _unidadeService = UnidadeService();
  bool _isLoading = false;

  void _saveUnidade() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final novaUnidade = Unidade(
          nome: _nomeController.text,
          endereco: _enderecoController.text,
        );
        // Usa o CNPJ da empresa que recebemos via 'widget.empresa'
        await _unidadeService.createUnidade(
          novaUnidade,
          empresaCnpj: widget.empresa.cnpj,
        );
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // O título agora usa o nome da empresa
      appBar: AppBar(title: Text('Nova Unidade para ${widget.empresa.nome}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome da Unidade'),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: _enderecoController,
                decoration: const InputDecoration(labelText: 'Endereço'),
              ),
              // Não precisamos mais do dropdown, pois a empresa já foi definida
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveUnidade,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
