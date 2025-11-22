// lib/screens/contracts_screen.dart (Exemplo de como ficaria)
import 'package:flutter/material.dart';
import '../models/usuario_model.dart'; // Você vai precisar passar o usuário para ContractsScreen
import '../widgets/scaffold_with_drawer.dart';

class ContractsScreen extends StatelessWidget {
  final Usuario usuario; // Adicione o usuario ao construtor
  const ContractsScreen(
      {super.key, required this.usuario}); // Ajuste o construtor

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithDrawer(
      // Usando o ScaffoldWithDrawer
      title: 'Gerenciar Contratos',
      usuario: usuario, // Passa o usuário
      body: Center(
        child: Text('Tela de Gerenciar Contratos'),
      ),
    );
  }
}
