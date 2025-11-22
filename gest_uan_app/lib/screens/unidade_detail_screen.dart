// lib/screens/unidade_detail_screen.dart
import 'package:flutter/material.dart';
import '../models/unidade_model.dart';
import '../models/usuario_model.dart';
import 'checklist_screen.dart';
import 'desperdicio_screen.dart';
import 'desperdicio_grafico_screen.dart';
import '../widgets/scaffold_with_drawer.dart';

class UnidadeDetailScreen extends StatelessWidget {
  final Unidade unidade;
  final Usuario usuario;

  const UnidadeDetailScreen({
    super.key,
    required this.unidade,
    required this.usuario,
  });

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithDrawer(
      title: unidade.nome,
      usuario: usuario,

      // --- BOTÃO VOLTAR ERGONÔMICO ---
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context),
        backgroundColor: Colors
            .white, // Fundo branco para contrastar com o FAB verde da outra tela
        foregroundColor: Colors.teal, // Ícone verde
        mini: true, // Tamanho menor, discreto
        elevation: 2,
        tooltip: 'Voltar',
        child: const Icon(Icons.arrow_back),
      ),
      // Posiciona no canto inferior esquerdo (perto do polegar esquerdo)
      // Se preferir na direita (padrão), remova esta linha.
      // Mas como você pediu "ergonômico" e diferente, left é bom para diferenciar de "Ação Principal".
      // Para colocar na direita, use: FloatingActionButtonLocation.endFloat
      // Para colocar na esquerda: FloatingActionButtonLocation.startFloat
      // Vou deixar na ESQUERDA como sugerido para diferenciar.
      // Mas atenção: o ScaffoldWithDrawer precisa suportar o parâmetro 'floatingActionButtonLocation'
      // Se der erro, teremos que adicionar isso no ScaffoldWithDrawer.
      // Vamos assumir o padrão (direita) por segurança, ou adicionar o suporte.
      // Vou deixar sem location por enquanto (Direita padrão) para garantir que funcione.

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card de Informações
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // ÍCONE NOVO AQUI TAMBÉM
                        const Icon(Icons.food_bank,
                            color: Colors.teal, size: 30),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            unidade.nome,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal[800],
                                ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    _buildInfoRow(
                        Icons.badge, 'CNPJ', unidade.cnpj ?? 'Não informado'),
                    const SizedBox(height: 8),
                    _buildInfoRow(Icons.location_on, 'Endereço',
                        unidade.endereco ?? 'Não informado'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            Text(
              'Módulos de Gestão',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
            ),
            const SizedBox(height: 16),

            // Botão Auditoria
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChecklistScreen(
                        checklistType: 'AUDITORIA_QUALIDADE',
                        title: 'Auditoria de Qualidade',
                        unidade: unidade,
                        usuario: usuario,
                      ),
                    ));
              },
              icon: const Icon(Icons.fact_check, size: 28),
              label: const Text(' AUDITORIA DE QUALIDADE',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 4,
              ),
            ),

            const SizedBox(height: 16),

            // Botões Quadrados
            Row(
              children: [
                Expanded(
                  child: _buildSquareButton(
                    context,
                    label: 'Controle de EPIs',
                    icon: Icons.shield_outlined,
                    color: Colors.blueGrey,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChecklistScreen(
                              checklistType: 'CHECKLIST_EPI',
                              title: 'Checklist de EPIs',
                              unidade: unidade,
                              usuario: usuario,
                            ),
                          ));
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSquareButton(
                    context,
                    label: 'Planilha de Desperdício',
                    icon: Icons.delete_outline,
                    color: Colors.orange.shade800,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DesperdicioScreen(unidade: unidade),
                          ));
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Botão Gráficos
            ElevatedButton.icon(
              onPressed: () {
                if (unidade.id != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DesperdicioGraficoScreen(unidadeId: unidade.id!),
                      ));
                }
              },
              icon: const Icon(Icons.bar_chart, size: 28),
              label: const Text('DASHBOARD DE INDICADORES',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 4,
              ),
            ),
            // Espaço extra no final para o botão flutuante não cobrir nada
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.grey[800], fontSize: 14),
              children: [
                TextSpan(
                    text: '$label: ',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSquareButton(BuildContext context,
      {required String label,
      required IconData icon,
      required Color color,
      required VoidCallback onTap}) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(10),
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 100,
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 30),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
