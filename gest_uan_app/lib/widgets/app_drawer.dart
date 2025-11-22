// lib/widgets/app_drawer.dart
import 'package:flutter/material.dart';
import '../models/usuario_model.dart';
import '../screens/company_list_screen.dart';
import '../screens/contracts_screen.dart';
import '../screens/home_screen.dart';

class AppDrawer extends StatelessWidget {
  final Usuario usuario;

  const AppDrawer({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // --- CABEÇALHO (TEAL) ---
          UserAccountsDrawerHeader(
            accountName: Text(
              usuario.nome,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            accountEmail: Text(usuario.email),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 50, color: Colors.teal),
            ),
            decoration: const BoxDecoration(
              color: Colors.teal,
            ),
          ),

          // --- ITENS DO MENU ---

          // Item: Painel Principal
          ListTile(
            leading: const Icon(Icons.home, color: Colors.teal),
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

          const Divider(),

          // Item: Gerenciar Empresas
          ListTile(
            leading: const Icon(Icons.business, color: Colors.teal),
            title: const Text('Gerenciar Empresas'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CompanyListScreen(usuario: usuario)),
              );
            },
          ),

          // Item: Gerenciar Contratos
          ListTile(
            leading: const Icon(Icons.description, color: Colors.teal),
            title: const Text('Gerenciar Contratos'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    // --- CORREÇÃO AQUI ---
                    // Removemos o 'const' e passamos o 'usuario'
                    builder: (context) => ContractsScreen(usuario: usuario)),
              );
            },
          ),
        ],
      ),
    );
  }
}
