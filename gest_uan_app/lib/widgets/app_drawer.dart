// lib/widgets/app_drawer.dart
import 'package:flutter/material.dart';
import '../models/usuario_model.dart';
import '../screens/company_list_screen.dart';
import '../screens/contracts_screen.dart';
import '../screens/home_screen.dart';
// Removida a importação de desperdicio_screen, pois não é mais usada aqui

class AppDrawer extends StatelessWidget {
  final Usuario usuario;

  const AppDrawer({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // Cabeçalho
          UserAccountsDrawerHeader(
            accountName: Text(usuario.nome),
            accountEmail: Text(usuario.email),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 50, color: Colors.teal),
            ),
            decoration: const BoxDecoration(
              color: Colors.teal,
            ),
          ),
          // Item: Painel Principal
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Painel Principal'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeScreen(usuario: usuario)),
              );
            },
          ),
          // Item: Gerenciar Empresas (COM A CORREÇÃO)
          ListTile(
            leading: const Icon(Icons.business),
            title: const Text('Gerenciar Empresas'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                // CORREÇÃO AQUI: Passa o 'usuario' para a CompanyListScreen
                MaterialPageRoute(
                    builder: (context) => CompanyListScreen(usuario: usuario)),
              );
            },
          ),
          // Item: Gerenciar Contratos
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Gerenciar Contratos'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ContractsScreen()),
              );
            },
          ),
          // Item: Controle de Desperdício (REMOVIDO, POIS AGORA ESTÁ DENTRO DA UNIDADE)
        ],
      ),
    );
  }
}
