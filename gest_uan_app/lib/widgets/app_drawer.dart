import 'package:flutter/material.dart';
import '../models/usuario_model.dart';
import '../models/unidade_model.dart';
import '../screens/company_list_screen.dart';
import '../screens/contracts_screen.dart';
import '../screens/home_screen.dart';

class AppDrawer extends StatelessWidget {
  final Usuario usuario;

  // Unidade atual pode ser nula
  final Unidade? unidadeAtual;

  const AppDrawer({
    super.key,
    required this.usuario,
    this.unidadeAtual,
  });

  // Widget Helper para criar o botão quadrado compacto
  Widget _buildSquareButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required Color iconColor,
    Widget? topWidget,
    required bool isUnitCard,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
      child: Card(
        elevation: isUnitCard ? 4 : 0,
        shape: isUnitCard
            ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
            : null,
        child: SizedBox(
          width: 80.0,
          height: 80.0,
          child: InkWell(
            onTap: onTap,
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // NOVO CONTAINER QUADRADO DE FUNDO
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: iconColor.withOpacity(0.1),
                      ),
                      child: Center(
                        child: Icon(
                          icon,
                          color: iconColor,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 9.0),
                      maxLines: 2,
                    ),
                  ],
                ),
                if (topWidget != null)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: topWidget,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // 🛑 CORREÇÃO: AUMENTADA A LARGURA PARA 150 PARA CABER O TEXTO DO CABEÇALHO
      width: 150,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // --- CABEÇALHO ---
          UserAccountsDrawerHeader(
            accountName: Text(
              usuario.nome,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14, // Fonte reduzida
              ),
            ),
            accountEmail: Text(
              usuario.email,
              style: const TextStyle(fontSize: 11), // Fonte reduzida
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 50, color: Colors.teal),
            ),
            decoration: const BoxDecoration(color: Colors.teal),
          ),

          // --- CARD DA UNIDADE ATUAL (QUADRADO COM FUNDO QUADRADO) ---
          if (unidadeAtual != null) ...[
            _buildSquareButton(
              context: context,
              icon: Icons.restaurant,
              title: unidadeAtual!.nome,
              iconColor: Colors.teal.shade700,
              isUnitCard: true,
              onTap: () {
                Navigator.pop(context);
              },
              topWidget:
                  const Icon(Icons.remove_circle, color: Colors.red, size: 14),
            ),
            const Divider(),
          ],

          // --- MENU: PAINEL PRINCIPAL (QUADRADO) ---
          _buildSquareButton(
            context: context,
            icon: Icons.home,
            title: 'Painel',
            iconColor: Colors.teal,
            isUnitCard: false,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(usuario: usuario),
                ),
              );
            },
          ),

          const Divider(),

          // --- MENU: GERENCIAR EMPRESAS (QUADRADO) ---
          _buildSquareButton(
            context: context,
            icon: Icons.business,
            title: 'Empresas',
            iconColor: Colors.teal,
            isUnitCard: false,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CompanyListScreen(usuario: usuario),
                ),
              );
            },
          ),

          // --- MENU: GERENCIAR CONTRATOS (QUADRADO) ---
          _buildSquareButton(
            context: context,
            icon: Icons.description,
            title: 'Contratos',
            iconColor: Colors.teal,
            isUnitCard: false,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ContractsScreen(usuario: usuario),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
