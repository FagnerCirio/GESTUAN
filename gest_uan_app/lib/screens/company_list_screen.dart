// lib/screens/company_list_screen.dart
import 'package:flutter/material.dart';
import '../models/empresa_model.dart';
import '../models/usuario_model.dart'; // Importa o modelo
import '../services/empresa_service.dart';
import 'add_empresa_screen.dart';
import 'company_detail_screen.dart';

class CompanyListScreen extends StatefulWidget {
  // 1. TELA AGORA RECEBE O USUÁRIO
  final Usuario usuario;
  const CompanyListScreen({super.key, required this.usuario});

  @override
  State<CompanyListScreen> createState() => _CompanyListScreenState();
}

class _CompanyListScreenState extends State<CompanyListScreen> {
  final EmpresaService _empresaService = EmpresaService();
  late Future<List<Empresa>> _empresas;

  @override
  void initState() {
    super.initState();
    _loadEmpresas();
  }

  void _loadEmpresas() {
    setState(() {
      _empresas = _empresaService.getEmpresas();
    });
  }

  void _navigateToAddEmpresa() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddEmpresaScreen()),
    );
    if (result == true) {
      _loadEmpresas();
    }
  }

  void _navigateToDetail(Empresa empresa) {
    Navigator.push(
      context,
      MaterialPageRoute(
        // CORREÇÃO AQUI: Passa a empresa E o usuário
        builder: (context) => CompanyDetailScreen(
            empresa: empresa,
            usuario: widget.usuario // Passa o usuário recebido
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gerenciar Empresas')),
      drawer: Drawer(
          child:
              Container()), // Adiciona um drawer placeholder para consistência, se necessário
      body: FutureBuilder<List<Empresa>>(
        future: _empresas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma empresa cadastrada.'));
          }

          final empresas = snapshot.data!;
          return ListView.builder(
            itemCount: empresas.length,
            itemBuilder: (context, index) {
              final empresa = empresas[index];
              return ListTile(
                title: Text(empresa.nome),
                subtitle: Text('CNPJ: ${empresa.cnpj}'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _navigateToDetail(
                    empresa), // Chama a função que agora passa o usuário
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddEmpresa,
        tooltip: 'Adicionar Empresa',
        child: const Icon(Icons.add),
      ),
    );
  }
}
