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

  // Define as cores fixas para os tipos de desperdício (Pizza)
  final Map<String, Color> _colorMap = {
    'Resto Ingesta': Colors.red.shade400,
    'Sobras Limpas': Colors.blue.shade400,
  };
  final Color _defaultColor = Colors.grey.shade400; // Cor padrão

  @override
  void initState() {
    super.initState();
    _futureStats = _service.getStats(widget.unidadeId);
  }

  // --- Funções para o Gráfico de Pizza (Peso Total) ---
  List<PieChartSectionData> showingSections(List<DesperdicioStats> stats) {
    final double totalPeso = stats.fold(0, (sum, item) => sum + item.totalPeso);

    return List.generate(stats.length, (i) {
      final stat = stats[i];
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 18.0 : 14.0;
      final radius = isTouched ? 110.0 : 100.0;
      final double percentage =
          totalPeso > 0 ? (stat.totalPeso / totalPeso) * 100 : 0;
      final Color sliceColor = _colorMap[stat.tipo] ?? _defaultColor;

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
            ? _buildBadge(stat.tipo, stat.totalPeso, sliceColor)
            : null,
        badgePositionPercentageOffset: .98,
      );
    });
  }

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
  // ### ATUALIZADO PARA O TCC ###
  Widget _buildPerCapitaBarChart(List<DesperdicioStats> stats) {
    // META: 40g (Exemplo para o TCC)
    const double metaAceitavel = 40.0;

    double maxY = 0;

    final List<Map<String, dynamic>> perCapitaData = stats.map((stat) {
      final double perCapitaEmGramas = stat.totalRefeicoes > 0
          ? (stat.totalPeso / stat.totalRefeicoes) * 1000
          : 0;
      if (perCapitaEmGramas > maxY) {
        maxY = perCapitaEmGramas;
      }
      return {'tipo': stat.tipo, 'perCapita': perCapitaEmGramas};
    }).toList();

    // Ajusta a altura máxima do gráfico para caber a linha da meta
    maxY = maxY > metaAceitavel ? maxY * 1.2 : metaAceitavel * 1.2;
    if (maxY == 0) maxY = 60;

    List<BarChartGroupData> barGroups = [];
    for (int i = 0; i < perCapitaData.length; i++) {
      final data = perCapitaData[i];
      final double valor = data['perCapita'];

      // COR INTELIGENTE:
      // Se passar da meta = VERMELHO (Alerta)
      // Se estiver abaixo = VERDE (Eficiência)
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
      aspectRatio: 1.7,
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
              // Sem definir cor de fundo para evitar erro de versão
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                // Texto dinâmico no tooltip
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

  // Função para construir a legenda
  Widget _buildLegend(List<DesperdicioStats> stats) {
    return Wrap(
      spacing: 16.0,
      runSpacing: 8.0,
      alignment: WrapAlignment.center,
      children: stats.map((stat) {
        final Color color = _colorMap[stat.tipo] ?? _defaultColor;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 16, height: 16, color: color),
            const SizedBox(width: 8),
            Text(
                '${stat.tipo}: ${stat.totalPeso.toStringAsFixed(2)} Kg (Total)'),
          ],
        );
      }).toList(),
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
                  Text('Legenda (Peso Total Acumulado)',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  _buildLegend(stats),
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
                        sections: showingSections(stats),
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  Text('Desperdício Per Capita (gramas)',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  _buildPerCapitaBarChart(stats),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
