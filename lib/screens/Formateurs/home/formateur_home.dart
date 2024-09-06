import 'package:flutter/material.dart';
import 'package:ticketglob/services/auth_service.dart';
import 'package:ticketglob/utils.dart';

class FormateurHome extends StatelessWidget {
  const FormateurHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bienvenue Formateur ! "),
        actions: [
          IconButton(onPressed: (){
            AuthService().deconnexion();
          }, icon: const Icon( AppIcons.logout, color: Colors.red,))
        ],
      ),
    );
  }
}