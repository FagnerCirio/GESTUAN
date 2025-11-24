// lib/screens/company_detail_screen.dart
import 'package:flutter/material.dart';
import '../models/empresa_model.dart';
import '../models/usuario_model.dart';
import '../models/unidade_model.dart';
import '../services/unidade_service.dart';
import '../widgets/scaffold_with_drawer.dart';
import 'add_unidade_screen.dart';
import 'unidade_detail_screen.dart';

class CompanyDetailScreen extends StatefulWidget {
  final Empresa empresa;
  final Usuario usuario;

  const CompanyDetailScreen({
    super.key,
    required this.empresa,
    required this.usuario,
  });

  @override
  State<CompanyDetailScreen> createState() => _CompanyDetailScreenState();
}

class _CompanyDetailScreenState extends State<CompanyDetailScreen> {
  final UnidadeService _unidadeService = UnidadeService();
  late Future<List<Unidade>> _unidadesFuture;

  @override
  void initState() {
    super.initState();
    _carregarUnidades();
  }

  void _carregarUnidades() {
    setState(() {
      _unidadesFuture = _unidadeService.getUnidades();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithDrawer(
      title: widget.empresa.nome,
      usuario: widget.usuario,
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        heroTag: 'btnAdd',
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddUnidadeScreen(empresa: widget.empresa),
            ),
          ).then((_) => _carregarUnidades());
        },
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  border:
                      Border(bottom: BorderSide(color: Colors.teal.shade100)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("EMPRESA",
                        style: TextStyle(
                            color: Colors.teal[800],
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),
                    Text(widget.empresa.nome,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(widget.empresa.cnpj,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder<List<Unidade>>(
                  future: _unidadesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Erro: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('Nenhuma unidade.'));
                    }

                    final todasUnidades = snapshot.data!;
                    final unidadesDaEmpresa = todasUnidades.where((u) {
                      return u.empresa?.cnpj == widget.empresa.cnpj;
                    }).toList();

                    if (unidadesDaEmpresa.isEmpty) {
                      return const Center(
                          child: Text('Nenhuma unidade cadastrada.'));
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 3.66,
                      ),
                      itemCount: unidadesDaEmpresa.length,
                      itemBuilder: (context, index) {
                        final unidade = unidadesDaEmpresa[index];
                        return _buildUanSquareCard(context, unidade);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton(
              heroTag: 'btnVoltar',
              onPressed: () => Navigator.pop(context),
              backgroundColor: Colors.white,
              foregroundColor: Colors.teal,
              mini: true,
              child: const Icon(Icons.arrow_back),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUanSquareCard(BuildContext context, Unidade unidade) {
    return Stack(
      children: [
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: Colors.white,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UnidadeDetailScreen(
                    unidade: unidade,
                    usuario: widget.usuario,
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.local_dining,
                      size: 26,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    unidade.nome,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // 🔥 Botão de excluir reposicionado
        Positioned(
          top: -10,
          right: 280,
          child: IconButton(
            icon: const Icon(
              Icons.remove_circle,
              color: Colors.redAccent,
              size: 20,
            ),
            onPressed: () {
              if (unidade.id == null) return;

              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Remover Unidade?'),
                  content: Text('Deseja remover "${unidade.nome}"?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(ctx);
                        try {
                          await _unidadeService.deletarUnidade(unidade.id!);
                          _carregarUnidades();

                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Unidade removida.'),
                              ),
                            );
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Erro: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      child: const Text(
                        'Remover',
                        style: TextStyle(color: Colors.red),
                      ),
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
