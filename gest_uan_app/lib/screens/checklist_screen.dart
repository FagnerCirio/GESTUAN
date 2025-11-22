// lib/screens/checklist_screen.dart
import 'package:flutter/material.dart';
import '../models/checklist_item_model.dart';
import '../models/usuario_model.dart';
import '../models/unidade_model.dart';
import '../services/checklist_service.dart';
import 'package:collection/collection.dart';
import '../utils/pdf_generator.dart';
import 'package:open_file/open_file.dart';

class ChecklistScreen extends StatefulWidget {
  final String checklistType;
  final String title;
  final Unidade unidade;
  final Usuario usuario;

  const ChecklistScreen({
    super.key,
    required this.checklistType,
    required this.title,
    required this.unidade,
    required this.usuario,
  });

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  Future<Map<String, List<ChecklistItem>>>? _groupedItemsFuture;

  // --- CORREÇÃO DO ERRO ---
  // Removemos o 'late'. Agora é anulável (?)
  Map<String, List<ChecklistItem>>? _dadosCarregados;

  final ChecklistService _service = ChecklistService();
  final Map<int, String> _respostas = {};
  final Map<int, TextEditingController> _observacoesControllers = {};
  int _totalItems = 0;
  double _currentScore = 0.0;
  bool _isExporting = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadAndGroupItems();
  }

  void _loadAndGroupItems() {
    _groupedItemsFuture =
        _service.getChecklistItems(widget.checklistType).then((items) {
      _totalItems = items.length;
      for (var item in items) {
        final int itemId = item.id.toInt();
        _observacoesControllers.putIfAbsent(
            itemId, () => TextEditingController());
      }
      final grouped = groupBy(items, (ChecklistItem item) => item.secao);

      // Salva os dados na variável de cache assim que carregar
      _dadosCarregados = grouped;

      return grouped;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _updateScore());
    });
  }

  void _updateScore() {
    int scoreConforme = 0;
    int scoreNaoAplicavel = 0;
    _respostas.forEach((key, value) {
      if (value == 'C')
        scoreConforme++;
      else if (value == 'NA') scoreNaoAplicavel++;
    });
    final int itensConsiderados = _totalItems - scoreNaoAplicavel;
    if (itensConsiderados <= 0 || _totalItems == 0)
      _currentScore = 0.0;
    else
      _currentScore = (scoreConforme / itensConsiderados) * 100;
  }

  void _salvarChecklist() async {
    if (_respostas.length != _totalItems) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Por favor, responda todos os itens.'),
            backgroundColor: Colors.orange),
      );
      return;
    }
    if (_isSaving) return;

    setState(() => _isSaving = true);
    _updateScore();

    try {
      List<Map<String, dynamic>> respostasItens = [];
      _respostas.forEach((itemId, resposta) {
        final observacao = _observacoesControllers[itemId]?.text ?? '';
        respostasItens.add({
          'checklistItem': {'id': itemId},
          'resposta': resposta,
          'observacao': observacao,
        });
      });

      Map<String, dynamic> payload = {
        'unidade': {'id': widget.unidade.id},
        'usuario': {'crn': widget.usuario.crn},
        'checklistType': widget.checklistType,
        'pontuacaoFinal': _currentScore,
        'respostas': respostasItens,
      };

      await _service.salvarChecklistResposta(payload);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Checklist salvo com sucesso no servidor!'),
              backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      print("Erro ao salvar checklist: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Erro ao salvar: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _exportarChecklist() async {
    if (_respostas.length != _totalItems) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Responda todos os itens antes de exportar.'),
            backgroundColor: Colors.orange),
      );
      return;
    }
    if (_isExporting) return;

    setState(() => _isExporting = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Gerando PDF... Aguarde um momento.'),
          duration: Duration(seconds: 15)),
    );

    try {
      _updateScore();

      // --- CORREÇÃO DE SEGURANÇA ---
      // Verificamos se a variável já foi preenchida
      final groupedItems = _dadosCarregados;

      if (groupedItems == null) {
        throw Exception(
            "Os dados ainda estão carregando. Tente novamente em alguns segundos.");
      }

      final filePath = await generateChecklistPdf(
        checklistTitle: widget.title,
        groupedItems: groupedItems,
        respostas: _respostas,
        observacoesControllers: _observacoesControllers,
        score: _currentScore,
        nomeUsuario: widget.usuario.nome,
        nomeUnidade: widget.unidade.nome,
      );

      final openResult = await OpenFile.open(filePath);

      if (mounted) ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (openResult.type != ResultType.done) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('PDF salvo, mas não abriu: ${openResult.message}'),
                backgroundColor: Colors.orange),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('PDF gerado e aberto com sucesso!'),
                backgroundColor: Colors.green),
          );
        }
      }
    } catch (e) {
      print("Erro ao gerar PDF: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Erro: $e'), // Mensagem de erro mais limpa
              backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  // Helper para os botões de rádio (Design Horizontal)
  Widget _buildRadioOption(
      int itemId, String value, String label, Color activeColor) {
    final isSelected = _respostas[itemId] == value;
    return InkWell(
      onTap: () => setState(() {
        _respostas[itemId] = value;
        _updateScore();
      }),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<String>(
              value: value,
              groupValue: _respostas[itemId],
              activeColor: activeColor,
              visualDensity: VisualDensity.compact,
              onChanged: (val) => setState(() {
                _respostas[itemId] = val!;
                _updateScore();
              }),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? activeColor : Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _observacoesControllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                'Score: ${_currentScore.toStringAsFixed(1)}%',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
      body: FutureBuilder<Map<String, List<ChecklistItem>>>(
        future: _groupedItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('Nenhum item encontrado. Verifique o backend.'));
          }

          final groupedItems = snapshot.data!;
          final sections = groupedItems.keys.toList()..sort();

          return ListView.separated(
            padding: const EdgeInsets.only(bottom: 160),
            itemCount: sections.length,
            separatorBuilder: (context, index) =>
                const Divider(thickness: 1.5, height: 1.5, color: Colors.grey),
            itemBuilder: (context, sectionIndex) {
              final section = sections[sectionIndex];
              final itemsInSection = groupedItems[section]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    color: Colors.teal.shade100,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    child: Text(
                      section,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.teal.shade900,
                          ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: itemsInSection.length,
                    itemBuilder: (context, itemIndex) {
                      final item = itemsInSection[itemIndex];
                      final int itemId = item.id.toInt();

                      return ExpansionTile(
                        key: ValueKey('${widget.checklistType}_item_$itemId'),
                        title: Text(item.itemAvaliado,
                            style: const TextStyle(fontSize: 15)),
                        backgroundColor: Colors.white,
                        collapsedBackgroundColor: itemIndex % 2 == 0
                            ? Colors.grey.shade50
                            : Colors.white,
                        childrenPadding:
                            const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                        tilePadding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 4.0),
                        children: [
                          // Layout Horizontal dos Botões
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildRadioOption(
                                  itemId, 'C', 'Conforme', Colors.green),
                              _buildRadioOption(
                                  itemId, 'NC', 'Não Conf.', Colors.red),
                              _buildRadioOption(
                                  itemId, 'NA', 'N/A', Colors.grey),
                            ],
                          ),

                          if (_respostas[itemId] == 'NC') ...[
                            const SizedBox(height: 8),
                            TextField(
                              controller: _observacoesControllers[itemId],
                              decoration: const InputDecoration(
                                labelText:
                                    'Evidências / Observações (Obrigatório)',
                                hintText: 'Descreva a não conformidade...',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 12.0),
                                isDense: true,
                              ),
                              maxLines: 2,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: _isSaving ? null : _salvarChecklist,
            label: _isSaving ? const Text('Salvando...') : const Text('Salvar'),
            icon: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ))
                : const Icon(Icons.save),
            heroTag: 'saveChecklist',
            backgroundColor: _isSaving ? Colors.grey : Colors.teal,
          ),
          const SizedBox(height: 8),
          FloatingActionButton.extended(
            onPressed: _isExporting ? null : _exportarChecklist,
            label: _isExporting
                ? const Text('Gerando...')
                : const Text('Gerar PDF'),
            icon: _isExporting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ))
                : const Icon(Icons.picture_as_pdf),
            backgroundColor: Colors.blueGrey,
            heroTag: 'exportChecklist',
          ),
        ],
      ),
    );
  }
}
