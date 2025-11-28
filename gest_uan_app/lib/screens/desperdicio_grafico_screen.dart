// lib/screens/desperdicio_grafico_screen.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Importa a biblioteca de gráficos
import '../services/desperdicio_service.dart';
import '../models/desperdicio_stats_model.dart';

class DesperdicioGraficoScreen extends StatefulWidget {
  final int unidadeId;
  const DesperdicioGraficoScreen({super.key, required this.unidadeId});

  @override
  State<DesperdicioGraficoScreen> createState() =>
      _DesperdicioGraficoScreenState();
}

class _DesperdicioGraficoScreenState extends State<DesperdicioGraficoScreen> {
  final DesperdicioService _service = DesperdicioService();
  late Future<List<DesperdicioStats>> _futureStats;
  int touchedIndex = -1; // Para o gráfico de pizza

  // --- NOVA PALETA DE CORES VIBRANTES ---
  // Esta lista será usada para colorir dinamicamente as fatias
  final List<Color> _palette = [
    Colors.red.shade700,
    Colors.blue.shade700,
    Colors.green.shade700,
    Colors.orange.shade700,
    Colors.purple.shade700,
    Colors.teal.shade700,
    Colors.pink.shade700,
    Colors.indigo.shade700,
    Colors.cyan.shade700,
    Colors.amber.shade700,
    Colors.brown.shade700,
  ];

  // Mapa para armazenar as cores atribuídas dinamicamente a cada chave (Tipo - Destino)
  // Isso garante que a mesma chave sempre terá a mesma cor.
  final Map<String, Color> _assignedColors = {};
  int _paletteIndex = 0;
  final Color _defaultColor = Colors.grey.shade400; // Cor de fallback

  @override
  void initState() {
    super.initState();
    _futureStats = _service.getStats(widget.unidadeId);
  }

  // Função auxiliar para criar a chave Tipo+Destino
  String _getChartKey(DesperdicioStats stat) {
    // Usamos ?? 'Não Classificado' para garantir que nunca seja nulo
    final destino = stat.destino ?? 'Não Classificado';
    return '${stat.tipo} - $destino';
  }

  // --- Funções para o Gráfico de Pizza (Peso Total por TIPO E DESTINO) ---
  List<PieChartSectionData> showingSections(List<DesperdicioStats> stats) {
    final double totalPeso = stats.fold(0, (sum, item) => sum + item.totalPeso);

    // Reinicia o índice para garantir que novas chaves (em uma nova chamada de dados)
    // peguem cores sequenciais corretamente, mas chaves existentes mantêm a cor.
    _paletteIndex = 0;

    return List.generate(stats.length, (i) {
      final stat = stats[i];
      final key = _getChartKey(stat); // Chave Tipo - Destino
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 18.0 : 14.0;
      final radius = isTouched ? 110.0 : 100.0;
      final double percentage =
          totalPeso > 0 ? (stat.totalPeso / totalPeso) * 100 : 0;

      // LÓGICA DE COR DINÂMICA:
      // Se a chave não existe no mapa _assignedColors, atribui a próxima cor da _palette.
      final Color sliceColor = _assignedColors.putIfAbsent(key, () {
        final newColor = _palette[_paletteIndex % _palette.length];
        _paletteIndex++;
        return newColor;
      });

      return PieChartSectionData(
        color: sliceColor,
        value: stat.totalPeso,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: const [Shadow(color: Colors.black, blurRadius: 2)],
        ),
        badgeWidget: isTouched
            ? _buildBadge(
                key, stat.totalPeso, sliceColor) // Usa a chave Tipo + Destino
            : null,
        badgePositionPercentageOffset: .98,
      );
    });
  }

  // Atualizado para usar a chave Tipo + Destino
  Widget _buildBadge(String label, double value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: color.withAlpha((255 * 0.9).round()),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.white, width: 1)),
      child: Text(
        '$label\n${value.toStringAsFixed(2)} Kg',
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  // --- Funções para o Gráfico de Barras (Per Capita - GERENCIAL) ---
  Widget _buildPerCapitaBarChart(List<DesperdicioStats> stats) {
    const double metaAceitavel = 40.0;
    double maxY = 0;

    // NOVO: Consolidar os dados por TIPO (ignorando o DESTINO para este gráfico)
    Map<String, List<DesperdicioStats>> statsByTipo = {};
    for (var stat in stats) {
      statsByTipo.putIfAbsent(stat.tipo, () => []).add(stat);
    }

    final List<Map<String, dynamic>> perCapitaData =
        statsByTipo.entries.map((entry) {
      final tipo = entry.key;
      final List<DesperdicioStats> tipoStats = entry.value;

      // Soma o peso total e o número de refeições para o TIPO
      final double totalPesoConsolidado =
          tipoStats.fold(0, (sum, item) => sum + item.totalPeso);
      final int totalRefeicoesConsolidado =
          tipoStats.fold(0, (sum, item) => sum + item.totalRefeicoes).toInt();

      final double perCapitaEmGramas = totalRefeicoesConsolidado > 0
          ? (totalPesoConsolidado / totalRefeicoesConsolidado) * 1000
          : 0;

      if (perCapitaEmGramas > maxY) {
        maxY = perCapitaEmGramas;
      }
      return {'tipo': tipo, 'perCapita': perCapitaEmGramas};
    }).toList();

    // Reordenar para consistência, se necessário (opcional)
    perCapitaData.sort((a, b) => a['tipo'].compareTo(b['tipo']));

    // Ajusta a altura máxima do gráfico para caber a linha da meta
    maxY = maxY > metaAceitavel ? maxY * 1.2 : metaAceitavel * 1.2;
    if (maxY == 0) maxY = 100;

    List<BarChartGroupData> barGroups = [];
    for (int i = 0; i < perCapitaData.length; i++) {
      final data = perCapitaData[i];
      final double valor = data['perCapita'];

      // COR INTELIGENTE:
      Color corDaBarra =
          valor > metaAceitavel ? Colors.redAccent : Colors.green;

      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: valor,
              color: corDaBarra, // Cor dinâmica
              width: 30,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
              // Fundo cinza claro atrás da barra para facilitar leitura
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: maxY,
                color: Colors.grey.shade100,
              ),
            ),
          ],
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 3.0,
      child: BarChart(
        BarChartData(
          maxY: maxY,
          alignment: BarChartAlignment.spaceAround,
          barGroups: barGroups,

          // LINHA DE META (Tracejada Vermelha)
          extraLinesData: ExtraLinesData(
            horizontalLines: [
              HorizontalLine(
                y: metaAceitavel,
                color: Colors.red.withOpacity(0.8),
                strokeWidth: 2,
                dashArray: [5, 5], // Linha tracejada
                label: HorizontalLineLabel(
                  show: true,
                  alignment: Alignment.topRight,
                  padding: const EdgeInsets.only(right: 5, bottom: 5),
                  style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 10),
                  labelResolver: (line) =>
                      'META MÁX: ${metaAceitavel.toInt()}g',
                ),
              ),
            ],
          ),

          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  if (value == 0) {
                    return const Text('0g', style: TextStyle(fontSize: 10));
                  }
                  // Evita sobrepor o texto se estiver muito perto do topo
                  if (value >= meta.max * 0.9) return const Text('');
                  return Text('${value.toInt()}g',
                      style: const TextStyle(fontSize: 10));
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < perCapitaData.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(perCapitaData[index]['tipo'],
                          style: const TextStyle(
                              fontSize: 11, fontWeight: FontWeight.bold)),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 20), // Intervalo fixo para ficar limpo

          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                String status = rod.toY > metaAceitavel
                    ? "ACIMA DA META"
                    : "DENTRO DA META";
                return BarTooltipItem(
                  '${perCapitaData[groupIndex]['tipo']}\n',
                  const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: '${rod.toY.toStringAsFixed(1)} g / refeição\n',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.normal),
                    ),
                    TextSpan(
                      text: status,
                      style: TextStyle(
                          color: rod.toY > metaAceitavel
                              ? Colors.redAccent
                              : Colors.greenAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 10),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // Função para construir a legenda (Atualizada para usar Cores Dinâmicas)
  Widget _buildLegend(List<DesperdicioStats> stats) {
    return Wrap(
      spacing: 16.0,
      runSpacing: 8.0,
      alignment: WrapAlignment.center,
      children: stats.map((stat) {
        final key = _getChartKey(stat); // Chave Tipo - Destino

        // Usa a cor atribuída dinamicamente. Se showingSections ainda não rodou, usa o default.
        final Color color = _assignedColors[key] ?? _defaultColor;

        // Exibe a combinação Tipo + Destino
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 16, height: 16, color: color),
            const SizedBox(width: 8),
            Text('$key: ${stat.totalPeso.toStringAsFixed(2)} Kg (Total)'),
          ],
        );
      }).toList(),
    );
  }

  // WIDGET: Meta Explícita
  Widget _buildGoalLegend() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // SIMULAÇÃO VISUAL DA LINHA TRACEJADA
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              5, // Cria 5 pequenos traços
              (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1.0),
                child: Container(
                  width: 5, // Largura do traço
                  height: 2, // Altura da linha
                  color: Colors.red.withOpacity(0.8),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'A linha tracejada vermelha representa a META MÁXIMA ACEITÁVEL (40g/refeição).',
            style: TextStyle(fontSize: 12, color: Colors.red),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gráficos de Desperdício')),
      body: Center(
        child: FutureBuilder<List<DesperdicioStats>>(
          future: _futureStats,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('Erro ao carregar o gráfico: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'Não há dados suficientes para gerar o gráfico.\n\n'
                    'Por favor, adicione registros na tela "Planilha de Desperdício" primeiro.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              );
            }

            final stats = snapshot.data!;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // --- GRÁFICO DE PIZZA (COMPOSIÇÃO DO PESO) ---
                  Text(
                      'Legenda (Peso Total Acumulado - Detalhe por Destino)', // Título atualizado
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  _buildLegend(stats), // Agora mostra destino
                  const SizedBox(height: 32),
                  Text('Composição do Peso Total (Kg)',
                      style: Theme.of(context).textTheme.titleLarge),
                  SizedBox(
                    height: 300,
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback:
                              (FlTouchEvent event, pieTouchResponse) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  pieTouchResponse == null ||
                                  pieTouchResponse.touchedSection == null) {
                                touchedIndex = -1;
                                return;
                              }
                              touchedIndex = pieTouchResponse
                                  .touchedSection!.touchedSectionIndex;
                            });
                          },
                        ),
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 2,
                        centerSpaceRadius: 60,
                        sections: showingSections(stats), // Usa Tipo + Destino
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),

                  // --- GRÁFICO DE BARRAS (PER CAPITA) ---
                  Text(
                      'Desperdício Per Capita (gramas - Consolidado por Tipo)', // Título atualizado
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  _buildGoalLegend(), // Mostra explicitamente a meta
                  const SizedBox(height: 16),
                  _buildPerCapitaBarChart(stats), // Consolida por Tipo
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
