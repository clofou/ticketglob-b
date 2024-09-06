import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticketglob/role_wrapper.dart';
import 'package:ticketglob/screens/connexion/connexion_screen.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    return user==null ? const ConnexionScreen(): RoleWrapper(useruid: user.uid);
  }
}