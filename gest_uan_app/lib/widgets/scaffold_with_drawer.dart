// lib/widgets/scaffold_with_drawer.dart
import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../models/usuario_model.dart';
import '../screens/login_screen.dart'; // Importante para o redirecionamento

class ScaffoldWithDrawer extends StatelessWidget {
  final Widget body;
  final String title;
  final Usuario usuario;
  final List<Widget>? actions; // Ações extras (opcionais)
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  const ScaffoldWithDrawer({
    super.key,
    required this.body,
    required this.title,
    required this.usuario,
    this.actions,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          // Se alguma tela passar botões extras, eles aparecem primeiro
          if (actions != null) ...actions!,

          // --- MENU DE PERFIL E SAIR (PADRÃO EM TODAS AS TELAS) ---
          PopupMenuButton<String>(
            icon: const Icon(Icons.account_circle, color: Colors.white),
            tooltip: 'Menu do Usuário',
            onSelected: (value) {
              if (value == 'sair') {
                // LÓGICA DE LOGOUT
                // Remove todas as telas anteriores da pilha e vai para o Login
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              // Mostra o nome do usuário (apenas informativo)
              PopupMenuItem<String>(
                enabled: false,
                child: Text(
                  usuario.nome,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.teal),
                ),
              ),
              const PopupMenuDivider(),
              // Opção Sair
              const PopupMenuItem<String>(
                value: 'sair',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red, size: 20),
                    SizedBox(width: 8),
                    Text('Sair', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 8), // Um espacinho na direita
        ],
      ),
      drawer: AppDrawer(usuario: usuario),
      body: body,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}
