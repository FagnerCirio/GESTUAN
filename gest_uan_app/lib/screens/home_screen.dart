// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../models/usuario_model.dart';
import '../widgets/scaffold_with_drawer.dart';

class HomeScreen extends StatelessWidget {
  final Usuario usuario;
  const HomeScreen({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithDrawer(
      title: 'Painel Principal',
      usuario: usuario,
      // REMOVIDO: actions: [...]
      // (Não precisamos mais passar o menu aqui, o ScaffoldWithDrawer já cria ele sozinho)

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              SizedBox(
                height: 200,
                child: Image.asset(
                  'assets/images/logo.jpg', // .jpg conforme seu uso
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.restaurant_menu,
                        size: 80, color: Colors.grey);
                  },
                ),
              ),

              const SizedBox(height: 30),

              Text(
                'Bem-vindo(a),',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.grey[600]),
              ),
              Text(
                usuario.nome,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold, color: Colors.teal[800]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Selecione uma opção no menu lateral para começar.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
