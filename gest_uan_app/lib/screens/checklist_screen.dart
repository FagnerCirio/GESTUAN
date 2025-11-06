// lib/screens/checklist_screen.dart
import 'package:flutter/material.dart';
import '../models/checklist_item_model.dart';
import '../models/usuario_model.dart'; // Precisa do usuário logado
import '../models/unidade_model.dart'; // Precisa da unidade atual
import '../services/checklist_service.dart';
import 'package:collection/collection.dart';
import '../utils/pdf_generator.dart'; // Importa nosso gerador
import 'package:open_file/open_file.dart'; // Importa para abrir o arquivo

class ChecklistScreen extends StatefulWidget {
  final String checklistType;
  final String title;
  // A tela agora recebe a unidade e o usuário
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
  // Mapas e variáveis como antes
  Future<Map<String, List<ChecklistItem>>>? _groupedItemsFuture;
  final ChecklistService _service = ChecklistService();
  final Map<int, String> _respostas = {};
  final Map<int, TextEditingController> _observacoesControllers = {};
  int _totalItems = 0;
  double _currentScore = 0.0;
  bool _isExporting = false; // Flag para indicar que o PDF está sendo gerado

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
      return groupBy(items, (ChecklistItem item) => item.secao);
    });
    // Atualiza score inicial
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _updateScore());
    });
  }

  void _updateScore() {
    // Lógica de cálculo do score continua a mesma
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

  void _salvarChecklist() {
    if (_respostas.length != _totalItems) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Por favor, responda todos os itens.'),
            backgroundColor: Colors.orange),
      );
      return;
    }
    _updateScore();
    print("--- SALVANDO CHECKLIST: ${widget.title} ---");
    print("Unidade ID: ${widget.unidade.id}"); // Usa o ID da unidade recebida
    print("Pontuação Final: ${_currentScore.toStringAsFixed(1)}%");
    _respostas.forEach((itemId, resposta) {
      final observacao = _observacoesControllers[itemId]?.text ?? '';
      print("Item ID: $itemId, Resposta: $resposta, Observação: '$observacao'");
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Checklist salvo! (Verifique o console)'),
          backgroundColor: Colors.green),
    );
    // TODO: Implementar envio real para o backend
  }

  // FUNÇÃO ATUALIZADA PARA EXPORTAR PDF
  void _exportarChecklist() async {
    // Validação: só exporta se tudo estiver respondido
    if (_respostas.length != _totalItems) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Responda todos os itens antes de exportar.'),
            backgroundColor: Colors.orange),
      );
      return;
    }
    if (_isExporting) return; // Evita cliques múltiplos

    setState(() => _isExporting = true); // Mostra indicador de progresso
    // Mostra uma mensagem mais longa enquanto gera
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Gerando PDF... Aguarde um momento.'),
          duration: Duration(seconds: 15)),
    );

    try {
      // Garante que o score está atualizado
      _updateScore();

      // Pega o mapa agrupado (precisamos esperar o Future, se ainda não carregou)
      final groupedItems = await _groupedItemsFuture;
      if (groupedItems == null)
        throw Exception("Dados do checklist não carregados.");

      // Chama a função de geração de PDF, passando todos os dados necessários
      final filePath = await generateChecklistPdf(
        checklistTitle: widget.title,
        groupedItems: groupedItems,
        respostas: _respostas,
        observacoesControllers: _observacoesControllers,
        score: _currentScore,
        nomeUsuario: widget.usuario.nome, // Passa o nome do usuário logado
        nomeUnidade: widget.unidade.nome, // Passa o nome da unidade atual
      );

      // Tenta abrir o arquivo PDF gerado
      final openResult = await OpenFile.open(filePath);

      // Esconde a mensagem "Gerando..."
      if (mounted) ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (openResult.type != ResultType.done) {
        // Se não conseguiu abrir, mostra o caminho onde foi salvo
        print('Erro ao abrir PDF: ${openResult.message}');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'PDF salvo em "$filePath", mas não foi possível abrir automaticamente.'),
                backgroundColor: Colors.orange,
                duration: const Duration(seconds: 8)),
          );
        }
      } else {
        // Se conseguiu abrir, mostra mensagem de sucesso curta
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('PDF gerado e aberto com sucesso!'),
                backgroundColor: Colors.green),
          );
        }
      }
    } catch (e) {
      // Em caso de erro na geração ou salvamento
      print("Erro ao gerar PDF: $e");
      if (mounted) {
        ScaffoldMessenger.of(context)
            .hideCurrentSnackBar(); // Esconde a msg "Gerando..."
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Erro ao gerar PDF: $e'),
              backgroundColor: Colors.red),
        );
      }
    } finally {
      // Esconde o indicador de progresso, mesmo se der erro
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
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
          // --- O conteúdo do FutureBuilder (ListView.separated, etc.) ---
          // --- permanece exatamente o mesmo da versão anterior ---
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
                        key: PageStorageKey('item_$itemId'),
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
                          RadioListTile<String>(
                            title: const Text('Conforme (C)'),
                            value: 'C',
                            groupValue: _respostas[itemId],
                            onChanged: (value) => setState(() {
                              _respostas[itemId] = value!;
                              _updateScore();
                            }),
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            activeColor: Colors.teal,
                          ),
                          RadioListTile<String>(
                            title: const Text('Não Conforme (NC)'),
                            value: 'NC',
                            groupValue: _respostas[itemId],
                            onChanged: (value) => setState(() {
                              _respostas[itemId] = value!;
                              _updateScore();
                            }),
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            activeColor: Colors.teal,
                          ),
                          RadioListTile<String>(
                            title: const Text('Não se Aplica (NA)'),
                            value: 'NA',
                            groupValue: _respostas[itemId],
                            onChanged: (value) => setState(() {
                              _respostas[itemId] = value!;
                              _updateScore();
                            }),
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            activeColor: Colors.teal,
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _observacoesControllers[itemId],
                            decoration: const InputDecoration(
                              labelText: 'Evidências / Observações',
                              hintText: 'Digite aqui...',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 12.0),
                            ),
                            maxLines: 3,
                            style: const TextStyle(fontSize: 14),
                          ),
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
      // Botões Salvar e Exportar
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: _salvarChecklist,
            label: const Text('Salvar'),
            icon: const Icon(Icons.save),
            heroTag: 'saveChecklist',
            backgroundColor: Colors.teal, // Cor diferente
          ),
          const SizedBox(height: 8),
          FloatingActionButton.extended(
            // Mostra indicador de progresso enquanto gera o PDF
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
