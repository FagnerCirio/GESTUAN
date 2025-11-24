// lib/screens/add_empresa_screen.dart
import 'package:flutter/material.dart';
import '../models/empresa_model.dart';
import '../services/empresa_service.dart';

// Verifique se o nome da classe está EXATAMENTE assim
class AddEmpresaScreen extends StatefulWidget {
  const AddEmpresaScreen({super.key});

  @override
  _AddEmpresaScreenState createState() => _AddEmpresaScreenState();
}

class _AddEmpresaScreenState extends State<AddEmpresaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cnpjController = TextEditingController();
  final _nomeController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _empresaService = EmpresaService();
  bool _isLoading = false;

  void _saveEmpresa() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final novaEmpresa = Empresa(
          cnpj: _cnpjController.text,
          nome: _nomeController.text,
          endereco: _enderecoController.text,
        );
        await _empresaService.createEmpresa(novaEmpresa);
        Navigator.pop(context, true); // Retorna 'true' para indicar sucesso
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar  Empresa')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _cnpjController,
                decoration: const InputDecoration(labelText: 'CNPJ'),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Campo obrigatório'
                    : null,
              ),
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome da Empresa'),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Campo obrigatório'
                    : null,
              ),
              TextFormField(
                controller: _enderecoController,
                decoration: const InputDecoration(labelText: 'Endereço'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveEmpresa,
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
