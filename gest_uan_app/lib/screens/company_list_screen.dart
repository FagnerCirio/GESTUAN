// lib/screens/company_list_screen.dart
import 'package:flutter/material.dart';
import '../models/usuario_model.dart';
import '../models/empresa_model.dart';
import '../services/empresa_service.dart';
import 'company_detail_screen.dart';
import '../widgets/scaffold_with_drawer.dart';
import 'add_empresa_screen.dart';

class CompanyListScreen extends StatefulWidget {
  final Usuario usuario;
  const CompanyListScreen({super.key, required this.usuario});

  @override
  State<CompanyListScreen> createState() => _CompanyListScreenState();
}

class _CompanyListScreenState extends State<CompanyListScreen> {
  late Future<List<Empresa>> _empresasFuture;
  final EmpresaService _empresaService = EmpresaService();

  @override
  void initState() {
    super.initState();
    _carregarEmpresas();
  }

  void _carregarEmpresas() {
    setState(() {
      _empresasFuture = _empresaService.getEmpresas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithDrawer(
      title: 'Gerenciar Empresas',
      usuario: widget.usuario,

      // Botão Adicionar EMPRESA
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEmpresaScreen()),
          ).then((_) => _carregarEmpresas());
        },
      ),

      body: FutureBuilder<List<Empresa>>(
        future: _empresasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma empresa encontrada.'));
          } else {
            final empresas = snapshot.data!;

            return GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // 4 Colunas
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.0, // Quadrado
              ),
              itemCount: empresas.length,
              itemBuilder: (context, index) {
                final empresa = empresas[index];
                return _buildEmpresaCard(context, empresa);
              },
            );
          }
        },
      ),
    );
  }

  // --- CARD DE EMPRESA COM REMOÇÃO ---
  Widget _buildEmpresaCard(BuildContext context, Empresa empresa) {
    return Stack(
      children: [
        Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: Colors.white,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CompanyDetailScreen(
                    empresa: empresa,
                    usuario: widget.usuario,
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child:
                      const Icon(Icons.business, size: 24, color: Colors.blue),
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: Text(
                    empresa.nome,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // BOTÃO EXCLUIR (Canto direito superior)
        Positioned(
          top: -5,
          right: -5,
          child: IconButton(
            icon: const Icon(Icons.remove_circle,
                color: Colors.redAccent, size: 18),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Excluir Empresa?'),
                  content: Text(
                      'Deseja excluir "${empresa.nome}" e todas as suas unidades?'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancelar')),
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(ctx);
                        try {
                          await _empresaService.deletarEmpresa(empresa.cnpj);
                          _carregarEmpresas(); // Atualiza a tela
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Empresa removida.')));
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Erro: $e'),
                                backgroundColor: Colors.red));
                          }
                        }
                      },
                      child: const Text('Excluir',
                          style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
