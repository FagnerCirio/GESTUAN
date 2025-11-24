// lib/screens/unidade_list_screen.dart
import 'package:flutter/material.dart';
import '../models/empresa_model.dart';
import '../models/unidade_model.dart';
import '../models/usuario_model.dart';
import '../services/unidade_service.dart';
import 'add_unidade_screen.dart';
import 'unidade_detail_screen.dart';

class UnidadeListScreen extends StatefulWidget {
  final Empresa empresa;
  final Usuario usuario;

  const UnidadeListScreen({
    super.key,
    required this.empresa,
    required this.usuario,
  });

  @override
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
      _unidades = _unidadeService.getUnidades().then(
            (unidades) => unidades
                .where((u) => u.empresa?.cnpj == widget.empresa.cnpj)
                .toList(),
          );
    });
  }

  void _navigateToAddUnidade() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddUnidadeScreen(empresa: widget.empresa),
      ),
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
          usuario: widget.usuario,
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
              child: Text('Nenhuma unidade cadastrada para esta empresa.'),
            );
          }

          final unidades = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              itemCount: unidades.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 1.0,
              ),
              itemBuilder: (context, index) {
                final unidade = unidades[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: () => _navigateToDetail(unidade),
                    borderRadius: BorderRadius.circular(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.restaurant,
                            size: 32,
                            color: Colors.teal,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          unidade.nome,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
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
