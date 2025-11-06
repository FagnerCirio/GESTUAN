// lib/screens/desperdicio_grafico_screen.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Importa a biblioteca de gráficos
import '../services/desperdicio_service.dart';
import '../models/desperdicio_stats_model.dart';
import 'dart:math'; // Para usar 'Random'

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

  // Define as cores fixas para os tipos de desperdício
  final Map<String, Color> _colorMap = {
    'Resto Ingesta': Colors.red.shade400,
    'Sobras Limpas': Colors.blue.shade400,
  };
  final Color _defaultColor = Colors.grey.shade400; // Cor padrão

  @override
  void initState() {
    super.initState();
    // Inicia a busca pelos dados de estatísticas
    _futureStats = _service.getStats(widget.unidadeId);
  }

  // --- Funções para o Gráfico de Pizza (Peso Total) ---

  // Constrói as "fatias" do gráfico de pizza
  List<PieChartSectionData> showingSections(List<DesperdicioStats> stats) {
    // Calcula o peso total para poder calcular a porcentagem de cada fatia
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
        title: '${percentage.toStringAsFixed(1)}%', // Ex: "60.5%"
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: const [Shadow(color: Colors.black, blurRadius: 2)],
        ),
        // Mostra um "crachá" (badge) com mais detalhes ao tocar na fatia
        badgeWidget: isTouched
            ? _buildBadge(stat.tipo, stat.totalPeso, sliceColor)
            : null,
        badgePositionPercentageOffset: .98,
      );
    });
  }

  // Widget para o "crachá" que aparece ao tocar na fatia da pizza
  Widget _buildBadge(String label, double value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: color.withOpacity(0.9), // Cor da fatia com opacidade
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.white, width: 1)),
      child: Text(
        '$label\n${value.toStringAsFixed(2)} Kg', // Ex: "Resto Ingesta / 15.50 Kg"
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  // --- Funções para o Gráfico de Barras (Per Capita) ---

  // Constrói o gráfico de barras
  Widget _buildPerCapitaBarChart(List<DesperdicioStats> stats) {
    double maxY = 0; // Valor máximo do eixo Y (em gramas)

    // Calcula o per capita (em gramas) para cada tipo e descobre o valor máximo
    final List<Map<String, dynamic>> perCapitaData = stats.map((stat) {
      final double perCapitaEmGramas = stat.totalRefeicoes > 0
          ? (stat.totalPeso / stat.totalRefeicoes) *
              1000 // Converte Kg/pessoa para g/pessoa
          : 0;
      if (perCapitaEmGramas > maxY) {
        maxY = perCapitaEmGramas; // Atualiza o valor máximo
      }
      return {'tipo': stat.tipo, 'perCapita': perCapitaEmGramas};
    }).toList();

    maxY = maxY * 1.2; // Adiciona uma margem de 20% no topo do gráfico
    if (maxY == 0) maxY = 50; // Valor mínimo de 50g se não houver dados

    // Cria os grupos de barras (um para cada tipo de desperdício)
    List<BarChartGroupData> barGroups = [];
    for (int i = 0; i < perCapitaData.length; i++) {
      final data = perCapitaData[i];
      barGroups.add(
        BarChartGroupData(
          x: i, // Posição no eixo X
          barRods: [
            BarChartRodData(
              toY: data['perCapita'], // Altura da barra (valor em gramas)
              color: _colorMap[data['tipo']] ?? _defaultColor, // Cor
              width: 30, // Largura da barra
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
          ],
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 1.7, // Proporção do gráfico (largura/altura)
      child: BarChart(
        BarChartData(
            maxY: maxY, // Define o limite superior do eixo Y
            alignment:
                BarChartAlignment.spaceAround, // Espaçamento entre as barras
            barGroups: barGroups, // Nossos dados
            // Configuração dos Títulos dos Eixos
            titlesData: FlTitlesData(
              // Eixo Y (Esquerda) - Mostra os valores em gramas
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40, // Espaço para os números
                  getTitlesWidget: (value, meta) {
                    // Mostra labels de forma inteligente
                    if (value == 0)
                      return const Text('0g', style: TextStyle(fontSize: 10));
                    if (value == meta.max)
                      return Text('${value.toInt()}g',
                          style: const TextStyle(fontSize: 10));
                    return const Text(''); // Oculta outros labels
                  },
                ),
              ),
              // Eixo X (Baixo) - Mostra os nomes dos tipos
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
              // Esconde os eixos de cima e da direita
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false), // Sem bordas
            gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: maxY / 5), // Linhas de grade horizontais
            // Tooltip (dica) que aparece ao tocar na barra
            barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: Colors.blueGrey,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${perCapitaData[groupIndex]['tipo']}\n', // Linha 1: Nome
                  const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text:
                          '${rod.toY.toStringAsFixed(1)} g / refeição', // Linha 2: Valor
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.normal),
                    ),
                  ],
                );
              },
            ))),
      ),
    );
  }

  // Função para construir a legenda (usada para ambos os gráficos)
  Widget _buildLegend(List<DesperdicioStats> stats) {
    return Wrap(
      // Usa Wrap para quebrar a linha se tiver muitos itens
      spacing: 16.0, // Espaço horizontal
      runSpacing: 8.0, // Espaço vertical
      alignment: WrapAlignment.center,
      children: stats.map((stat) {
        final Color color = _colorMap[stat.tipo] ?? _defaultColor;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 16, height: 16, color: color), // Quadrado colorido
            const SizedBox(width: 8),
            // Mostra o Peso Total (Kg) na legenda
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
          future: _futureStats, // O Future que estamos esperando
          builder: (context, snapshot) {
            // Se estiver carregando
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            // Se der erro
            else if (snapshot.hasError) {
              return Center(
                  child: Text('Erro ao carregar o gráfico: ${snapshot.error}'));
            }
            // Se não tiver dados (ex: nenhum registro de desperdício ainda)
            else if (!snapshot.hasData || snapshot.data!.isEmpty) {
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

            // Se temos dados, construímos a tela
            final stats = snapshot.data!;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // 1. Legenda Geral (mostrando Peso Total)
                  Text('Legenda (Peso Total Acumulado)',
                      style: Theme.of(context).textTheme.titleMedium),
                  _buildLegend(stats),
                  const SizedBox(height: 32), // Espaço grande

                  // 2. Gráfico 1: Peso Total (Pizza)
                  Text('Composição do Peso Total (Kg)',
                      style: Theme.of(context).textTheme.titleLarge),
                  SizedBox(
                    height:
                        300, // Define uma altura fixa para o gráfico de pizza
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
                        centerSpaceRadius:
                            60, // Buraco no meio (Gráfico de Rosca)
                        sections:
                            showingSections(stats), // Nossos dados de pizza
                      ),
                    ),
                  ),

                  const SizedBox(height: 48), // Espaço grande

                  // 3. Gráfico 2: Per Capita (Barras)
                  Text('Desperdício Per Capita (gramas)',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  _buildPerCapitaBarChart(stats), // Nossos dados de barra
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
