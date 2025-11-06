// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../models/usuario_model.dart';
import '../widgets/app_drawer.dart'; // Importa o novo Drawer
import 'login_screen.dart';

enum MenuOption { configuracoes, sair }

class HomeScreen extends StatelessWidget {
  final Usuario usuario;
  const HomeScreen({super.key, required this.usuario});

  void _onMenuSelection(MenuOption item, BuildContext context) {
    switch (item) {
      case MenuOption.configuracoes:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Navegando para Configurações...')),
        );
        break;
      case MenuOption.sair:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (Route<dynamic> route) => false,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(usuario: usuario),

      appBar: AppBar(
        title: const Text('Painel Principal'),
        actions: [
          PopupMenuButton<MenuOption>(
            onSelected: (item) => _onMenuSelection(item, context),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Text(usuario.nome),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),

            itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuOption>>[
              const PopupMenuItem<MenuOption>(
                value: MenuOption.configuracoes,
                child: Text('Configurações'),
              ),
              const PopupMenuItem<MenuOption>(
                value: MenuOption.sair,
                child: Text('Sair'),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.restaurant_menu, size: 80, color: Colors.grey),
            const SizedBox(height: 20),
            Text(
              'Bem-vindo(a), ${usuario.nome}!',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const Text(
              'Selecione uma opção no menu lateral para começar.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
