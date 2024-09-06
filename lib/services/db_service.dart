import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ticketglob/models/ticket.dart';
import 'package:ticketglob/models/users_data.dart';

class DbService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  String? save({required collectionName, required Map<String, dynamic> data}) {
    db.collection(collectionName).add(data).then((documentSnapshot) {
      print("Added Data with ID: ${documentSnapshot.id}");
      return documentSnapshot.id;
    });
    return null;
  }

  Future<String?> update({
    required String collectionName,
    required String documentRef,
    required Map<String, Object?> data,
  }) async {
    try {
      await db.collection(collectionName).doc(documentRef).set(data);
      return documentRef; // On retourne la référence du document une fois l'opération terminée
    } catch (e) {
      print("Error writing document: $e");
      return null;
    }
  }

  bool delete({required collectionName, required documentRef}) {
    db.collection(collectionName).doc(documentRef).delete().then(
      (doc) {
        print("Document deleted");
        return true;
      },
      onError: (e) {
        print("Error updating document $e");
        return false;
      },
    );
    return false;
  }

  Stream<Map<String, dynamic>?> getRealtimeData(
      String collectionName, String documentRef) {
    final docRef =
        FirebaseFirestore.instance.collection(collectionName).doc(documentRef);

    // Retourne un Stream qui émet les mises à jour du document
    return docRef.snapshots().map((DocumentSnapshot doc) {
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        print(data);
        return data;
      } else {
        print("Document does not exist");
        return null;
      }
    }).handleError((e) {
      print("Error getting document: $e");
      return null;
    });
  }

  // Fonction pour récupérer les utilisateurs depuis Firebase Auth et Firestore
  Future<List<UserData>> fetchUsersFromFirestore() async {
    List<UserData> fetchedUsers = [];
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();

      for (var doc in querySnapshot.docs) {
        DateTime creationDate = (doc['creationDate'] as Timestamp).toDate();
        DateTime lastSignInDate = (doc['lastSignInDate'] as Timestamp).toDate();

        fetchedUsers.add(UserData(
          uid: doc.id,
          email: doc['email'],
          nomComplet: doc['nomComplet'],
          role: doc['role'],
          telephone: doc['telephone'],
          creationDate: creationDate,
          lastSignInDate: lastSignInDate,
        ));
      }
    } catch (e) {
      print('Erreur lors de la récupération des utilisateurs : $e');
    }
    return fetchedUsers;
  }

  Future<List<Ticket>> fetchTickets() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('tickets').get();
    return snapshot.docs.map((doc) => Ticket.fromFirestore(doc)).toList();
  }

  Stream<QuerySnapshot> get usersStream =>
      FirebaseFirestore.instance.collection('users').snapshots();
}
