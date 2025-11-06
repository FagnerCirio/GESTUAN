// lib/screens/desperdicio_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/desperdicio_model.dart';
import '../models/unidade_model.dart';
import '../services/desperdicio_service.dart';

class DesperdicioScreen extends StatefulWidget {
  final Unidade unidade;
  const DesperdicioScreen({super.key, required this.unidade});

  @override
  State<DesperdicioScreen> createState() => _DesperdicioScreenState();
}

class _DesperdicioScreenState extends State<DesperdicioScreen> {
  final _formKey = GlobalKey<FormState>();
  // NOVOS CONTROLLERS
  final _refeicoesController = TextEditingController();
  final _pesoController = TextEditingController();
  final _destinoController = TextEditingController();

  DateTime _dataSelecionada = DateTime.now();
  String _tipoSelecionado = 'Resto Ingesta';

  final _service = DesperdicioService();
  bool _isLoading = false;

  Future<void> _selecionarData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (data != null) {
      setState(() {
        _dataSelecionada = data;
      });
    }
  }

  void _saveRegistro() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final novoRegistro = Desperdicio(
          data: _dataSelecionada,
          tipo: _tipoSelecionado,
          // Garante que a conversão use ponto (ex: "10,5" vira "10.5")
          peso: double.parse(_pesoController.text.replaceAll(',', '.')),
          destino: _destinoController.text,
          // Converte o texto das refeições para inteiro
          numeroRefeicoes: int.parse(_refeicoesController.text),
        );

        if (widget.unidade.id != null) {
          await _service.createRegistro(widget.unidade.id!, novoRegistro);

          if (mounted) {
            Navigator.pop(context); // Volta para a tela anterior
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Registro salvo com sucesso!'),
                  backgroundColor: Colors.green),
            );
          }
        } else {
          throw Exception("ID da unidade não encontrado.");
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Erro ao salvar: $e'),
                backgroundColor: Colors.red),
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
  void dispose() {
    _refeicoesController.dispose(); // Limpa o novo controller
    _pesoController.dispose();
    _destinoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Desperdício - ${widget.unidade.nome}')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          // Permite rolar a tela
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Seletor de Data
              ListTile(
                title: Text(
                    "Data: ${DateFormat('dd/MM/yyyy').format(_dataSelecionada)}"),
                trailing: const Icon(Icons.calendar_today),
                onTap: _selecionarData,
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 16),

              // NOVO CAMPO: NÚMERO DE REFEIÇÕES
              TextFormField(
                controller: _refeicoesController,
                decoration: const InputDecoration(
                  labelText: 'Nº de Refeições Servidas',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.people_outline),
                ),
                keyboardType: TextInputType.number, // Teclado numérico
                validator: (v) {
                  // Validação
                  if (v == null || v.isEmpty) return 'Campo obrigatório';
                  if (int.tryParse(v) == null)
                    return 'Valor inválido (use número inteiro)';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Seletor de Tipo
              DropdownButtonFormField<String>(
                value: _tipoSelecionado,
                items: ['Resto Ingesta', 'Sobras Limpas'].map((String value) {
                  return DropdownMenuItem<String>(
                      value: value, child: Text(value));
                }).toList(),
                onChanged: (newValue) {
                  if (newValue != null) {
                    setState(() => _tipoSelecionado = newValue);
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Tipo de Desperdício',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.food_bank_outlined),
                ),
              ),
              const SizedBox(height: 16),

              // Campo para o Peso
              TextFormField(
                controller: _pesoController,
                decoration: const InputDecoration(
                  labelText: 'Peso (Kg)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.scale_outlined),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Campo obrigatório';
                  if (double.tryParse(v.replaceAll(',', '.')) == null)
                    return 'Valor inválido (use 10,5 ou 10.5)';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campo para o Destino
              TextFormField(
                controller: _destinoController,
                decoration: const InputDecoration(
                  labelText: 'Destino',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.recycling_outlined),
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 24),

              // Botão Salvar
              ElevatedButton(
                onPressed: _isLoading ? null : _saveRegistro,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ))
                    : const Text('Salvar Registro'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
