import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ticketglob/role_wrapper.dart';
import 'package:ticketglob/services/auth_service.dart';
import 'package:ticketglob/utils.dart';

class ConnexionScreen extends StatelessWidget {
  const ConnexionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String mail = "";
    String password = "";
    final key = GlobalKey<FormState>();
    bool isDesktop = false;

    if (kIsWeb) {
      // Si l'application s'exécute sur le web, ce n'est pas nécessairement un desktop
      // Mais vous pouvez ajuster cette vérification en fonction des besoins
      isDesktop = true;
    } else if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      // Vérification si l'application s'exécute sur un système d'exploitation desktop
      isDesktop = true;
    }

    Widget formulaireDeConnexion = SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.medium, horizontal: AppSpacing.large),
      child: Form(
        key: key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.35,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/login.png'))),
            ),
            const SizedBox(
              height: AppSpacing.medium,
            ),
            const Text(
              "Bienvenue!",
              style: AppTextStyles.headline1,
            ),
            const SizedBox(
              height: AppSpacing.large,
            ),
            SizedBox(
              height: 45,
              child: TextFormField(
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: AppGlobal.inputDecoration(context, hintText: "Email"),
                onChanged: (value) => mail = value,
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            const SizedBox(
              height: AppSpacing.small,
            ),
            SizedBox(
              height: 45,
              child: TextFormField(
                obscureText: true,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: AppGlobal.inputDecoration(context, hintText: "Mot de Passe"),
                onChanged: (value) => password = value,
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            TextButton(
              child: const Text("Vous avez oublié vôtre mot de passe ?"),
              onPressed: () {},
            ),
            const SizedBox(
              height: AppSpacing.medium,
            ),
            Center(
              child: CustomButton(
                  text: "Se Connecter",
                  onPressed: () async {
                    if (key.currentState!.validate()) {
                      String? result = await AuthService()
                          .connexion(emailAddress: mail, password: password);
                          

                      if (result == null) {
                        ScaffoldMessenger.of(context).showSnackBar(AppGlobal.snackdemo(message: 'Email ou mot de passe incorrect !', backgroundColor: Colors.red));
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => RoleWrapper(useruid: result),));
                      }
                    } else {
                      
                    }
                  }),
            )
          ],
        ),
      ),
    );

    return SafeArea(
      child: Scaffold(
          body: isDesktop
              ? Center(
                  child: SizedBox(
                    width: 700,
                    height: 600,
                    child: Card(
                      child: formulaireDeConnexion,
                    ),
                  ),
                )
              : formulaireDeConnexion),
    );
  }
}

