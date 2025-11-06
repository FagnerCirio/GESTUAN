// lib/screens/unidade_detail_screen.dart
import 'package:flutter/material.dart';
// Certifique-se que os modelos estão importados
import '../models/unidade_model.dart';
import '../models/usuario_model.dart';
import 'checklist_screen.dart';
import 'desperdicio_screen.dart';
// Certifique-se que a tela de gráfico está importada
import 'desperdicio_grafico_screen.dart';

class UnidadeDetailScreen extends StatelessWidget {
  final Unidade unidade;
  // A tela recebe o usuário da tela anterior
  final Usuario usuario;

  const UnidadeDetailScreen({
    super.key,
    required this.unidade,
    required this.usuario, // Construtor recebe o usuário
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(unidade.nome), // Título com o nome da unidade
      ),
      body: SingleChildScrollView(
        // Permite rolagem se tiver muitos botões
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Seção de Detalhes da Unidade ---
            Text('Detalhes da Unidade',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            Card(
              elevation: 2, // Sombra suave
              child: ListTile(
                title: Text(unidade.nome,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('CNPJ: ${unidade.cnpj ?? 'Não informado'}\n'
                    'Endereço: ${unidade.endereco ?? 'Não informado'}\n'
                    'Empresa Prestadora: ${unidade.empresa?.nome ?? 'Não informada'}'),
                isThreeLine: true, // Permite mais espaço para o subtítulo
              ),
            ),
            const SizedBox(height: 24),

            // --- Seção de Funcionalidades ---
            Text('Funcionalidades',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),

            // --- Botões para Checklists ---
            Text('Checklists:', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),

            // Botão Checklist de Auditoria
            ElevatedButton.icon(
              onPressed: () {
                // CORREÇÃO AQUI: Passa os parâmetros 'unidade' e 'usuario'
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChecklistScreen(
                        checklistType: 'AUDITORIA_QUALIDADE',
                        title: 'Auditoria de Qualidade',
                        unidade: unidade, // Passa a unidade atual
                        usuario: usuario, // Passa o usuário logado
                      ),
                    ));
              },
              icon: const Icon(Icons.checklist_rtl_outlined), // Ícone diferente
              label: const Text('Auditoria de Qualidade'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(45), // Altura do botão
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
            const SizedBox(height: 10),

            // Botão Checklist de Limpeza
            ElevatedButton.icon(
              onPressed: () {
                // CORREÇÃO AQUI: Passa os parâmetros 'unidade' e 'usuario'
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChecklistScreen(
                        checklistType: 'LIMPEZA',
                        title: 'Checklist de Limpeza',
                        unidade: unidade, // Passa a unidade atual
                        usuario: usuario, // Passa o usuário logado
                      ),
                    ));
              },
              icon: const Icon(Icons.cleaning_services_outlined),
              label: const Text('Limpeza'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(45),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
            const SizedBox(height: 10),

            // Botão Checklist de Refrigeração
            ElevatedButton.icon(
              onPressed: () {
                // CORREÇÃO AQUI: Passa os parâmetros 'unidade' e 'usuario'
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChecklistScreen(
                        checklistType: 'REFRIGERACAO',
                        title: 'Controle de Refrigeração',
                        unidade: unidade, // Passa a unidade atual
                        usuario: usuario, // Passa o usuário logado
                      ),
                    ));
              },
              icon: const Icon(Icons.ac_unit_outlined),
              label: const Text('Refrigeração'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(45),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
            const SizedBox(height: 10),

            // Botão Checklist de EPIs
            ElevatedButton.icon(
              onPressed: () {
                // CORREÇÃO AQUI: Passa os parâmetros 'unidade' e 'usuario'
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChecklistScreen(
                        checklistType: 'EPIS',
                        title: 'Checklist de EPIs',
                        unidade: unidade, // Passa a unidade atual
                        usuario: usuario, // Passa o usuário logado
                      ),
                    ));
              },
              icon: const Icon(Icons.shield_outlined),
              label: const Text('EPIs'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(45),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),

            const SizedBox(height: 24), // Espaço maior

            // --- Botões para Desperdício ---
            Text('Desperdício:',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),

            // Botão Planilha de Desperdício
            ElevatedButton.icon(
              onPressed: () {
                // Navega para a tela de desperdício, passando a unidade
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DesperdicioScreen(unidade: unidade),
                    ));
              },
              icon: const Icon(Icons.delete_sweep_outlined),
              label: const Text('Planilha de Desperdício'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade700,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(45),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
            const SizedBox(height: 10),

            // Botão Gráficos de Desperdício
            ElevatedButton.icon(
              onPressed: () {
                // Verifica se unidade.id não é nulo antes de navegar
                if (unidade.id != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DesperdicioGraficoScreen(unidadeId: unidade.id!),
                      ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Erro: ID da unidade não encontrado.'),
                        backgroundColor: Colors.red),
                  );
                }
              },
              icon: const Icon(Icons.pie_chart_outline),
              label: const Text('Visualizar Gráficos'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(45),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
