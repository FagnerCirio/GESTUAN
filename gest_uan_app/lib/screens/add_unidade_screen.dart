// lib/screens/add_unidade_screen.dart
import 'package:flutter/material.dart';
import '../models/empresa_model.dart';
import '../models/unidade_model.dart';
import '../services/unidade_service.dart';

class AddUnidadeScreen extends StatefulWidget {
  final Empresa empresa;

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
        // 1. Criamos o objeto Unidade JÁ vinculando a empresa nele
        final novaUnidade = Unidade(
          id: null, // O backend gera o ID
          nome: _nomeController.text,
          endereco: _enderecoController.text,
          cnpj: '', // Se não tiver campo de CNPJ nesta tela, mandamos vazio
          empresa: widget.empresa, // <--- VINCULA A EMPRESA AQUI
        );

        // 2. Chamamos o método correto 'cadastrarUnidade'
        await _unidadeService.cadastrarUnidade(novaUnidade);

        if (mounted) {
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Unidade para ${widget.empresa.nome}'),
        backgroundColor: Colors.teal, // Mantendo o padrão visual
        foregroundColor: Colors.white,
      ),
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveUnidade,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
