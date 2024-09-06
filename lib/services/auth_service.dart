import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ticketglob/models/users_data.dart';
import 'package:ticketglob/services/db_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> connexion({String? emailAddress, String? password}) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
          email: emailAddress!, password: password!);

      if (credential.user == null) {
        return null;
      } else {
        User user = credential.user!;
        DateTime lastSignInDate = user.metadata.lastSignInTime!;

        // Mise à jour de la date de dernière connexion dans Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          "lastSignInDate": lastSignInDate,
        });
        return credential.user!.uid;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
    return null;
  }

  Future<Map<String, Object>> inscription({
    required String emailAddress,
    required String password,
    required String role,
    required String nomComplet,
    required String telephone,
  }) async {
    String errorMessage = "";
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      User useruser = credential.user!;
      DateTime creationDate = useruser.metadata.creationTime!;
      DateTime lastSignInDate = useruser.metadata.lastSignInTime!;

      UserData user = UserData(
          uid: useruser.uid,
          nomComplet: nomComplet,
          email: emailAddress,
          role: role,
          telephone: telephone,
          creationDate: creationDate,
          lastSignInDate: lastSignInDate);

      final resultSaveFirestore = await DbService().update(
        collectionName: "users",
        documentRef: credential.user!.uid,
        data: {
          "uid": user.uid,
          "email": user.email,
          "nomComplet": user.nomComplet,
          "role": user.role,
          "telephone": user.telephone,
          "creationDate": user.creationDate,
          "lastSignInDate": user.lastSignInDate,
        },
      );

      if (resultSaveFirestore == null) {
        throw Exception("Erreur lors de l'enregistrement dans Firestore");
      }

      return {"result": credential.user!.uid, "isOk": true};
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        errorMessage = "Le Mot de passe est trop faible";
      } else if (e.code == 'email-already-in-use') {
        errorMessage = "Le Compte existe déjà";
      } else {
        errorMessage = "Erreur de création du compte: ${e.message}";
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception("Erreur inattendue: ${e.toString()}");
    }
  }

  deconnexion() {
    _auth.signOut();
  }

  // Créez un StreamController personnalisé
  final StreamController<User?> _userStreamController =
      StreamController<User?>();

  AuthService() {
    // Ecoute du authStateChanges
    _auth.authStateChanges().listen((User? user) {
      if (_shouldEmitLoginEvent) {
        _userStreamController.add(user);
      }
    });
  }

  // Un flag pour savoir si on doit émettre un événement de connexion
  final bool _shouldEmitLoginEvent = true;

  // Stream personnalisé pour les utilisateurs connectés
  Stream<User?> get user => _userStreamController.stream;
}
