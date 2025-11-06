// lib/screens/unidade_list_screen.dart
import 'package:flutter/material.dart';
import '../models/empresa_model.dart';
import '../models/unidade_model.dart';
import '../models/usuario_model.dart'; // IMPORTA O MODELO DE USUÁRIO
import '../services/unidade_service.dart';
import 'add_unidade_screen.dart';
import 'unidade_detail_screen.dart';

class UnidadeListScreen extends StatefulWidget {
  final Empresa empresa;
  final Usuario usuario; // 1. TELA AGORA RECEBE O USUÁRIO

  const UnidadeListScreen(
      {super.key,
      required this.empresa,
      required this.usuario // 2. ADICIONADO AO CONSTRUTOR
      });

  @override
  // 3. CORREÇÃO DA ASSINATURA DO CREATESTATE
  State<UnidadeListScreen> createState() => _UnidadeListScreenState();
}

class _UnidadeListScreenState extends State<UnidadeListScreen> {
  final UnidadeService _unidadeService = UnidadeService();
  late Future<List<Unidade>> _unidades;

  @override
  void initState() {
    super.initState();
    _loadUnidades();
  }

  void _loadUnidades() {
    setState(() {
      _unidades = _unidadeService.getUnidades().then((unidades) => unidades
          .where((u) => u.empresa?.cnpj == widget.empresa.cnpj)
          .toList());
    });
  }

  void _navigateToAddUnidade() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddUnidadeScreen(empresa: widget.empresa)),
    );
    if (result == true) {
      _loadUnidades();
    }
  }

  void _navigateToDetail(Unidade unidade) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UnidadeDetailScreen(
          unidade: unidade,
          usuario: widget.usuario, // 4. PASSA O USUÁRIO PARA A TELA DE DETALHES
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Unidades de ${widget.empresa.nome}')),
      body: FutureBuilder<List<Unidade>>(
        future: _unidades,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('Nenhuma unidade cadastrada para esta empresa.'));
          }

          final unidades = snapshot.data!;
          return ListView.builder(
            itemCount: unidades.length,
            itemBuilder: (context, index) {
              final unidade = unidades[index];
              return ListTile(
                title: Text(unidade.nome),
                subtitle: Text('CNPJ: ${unidade.cnpj ?? 'Não informado'}'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _navigateToDetail(unidade),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddUnidade,
        tooltip: 'Adicionar Unidade',
        child: const Icon(Icons.add),
      ),
    );
  }
}
