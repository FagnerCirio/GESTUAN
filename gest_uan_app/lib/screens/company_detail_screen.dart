// lib/screens/company_detail_screen.dart
import 'package:flutter/material.dart';
// Certifique-se de importar os modelos necessários
import '../models/empresa_model.dart';
import '../models/usuario_model.dart';
// Importa a tela de lista de unidades
import 'unidade_list_screen.dart';

class CompanyDetailScreen extends StatelessWidget {
  final Empresa empresa;
  // A tela recebe o usuário da tela anterior (CompanyListScreen)
  final Usuario usuario;

  const CompanyDetailScreen(
      {super.key,
      required this.empresa,
      required this.usuario // Construtor recebe o usuário
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(empresa.nome), // Título com o nome da empresa
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Seção de Detalhes da Empresa ---
            Text('Detalhes da Empresa',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              child: ListTile(
                title: Text(empresa.nome,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(
                    'CNPJ: ${empresa.cnpj}\n' // CNPJ é obrigatório, não precisa de fallback
                    'Endereço: ${empresa.endereco ?? 'Não informado'}'),
                isThreeLine: true,
              ),
            ),
            const SizedBox(height: 24),

            // --- Seção de Gerenciamento ---
            Text('Gerenciamento',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),

            // Botão para Gerenciar Unidades
            ElevatedButton.icon(
              onPressed: () {
                // CORREÇÃO AQUI: Passa os parâmetros 'empresa' e 'usuario'
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UnidadeListScreen(
                      empresa: empresa, // Passa a empresa atual
                      usuario: usuario, // Passa o usuário logado
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.store_outlined), // Ícone
              label: const Text('Gerenciar Unidades'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50), // Botão maior
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
            // Outros botões de gerenciamento da empresa (ex: editar empresa) podem vir aqui
          ],
        ),
      ),
    );
  }
}
