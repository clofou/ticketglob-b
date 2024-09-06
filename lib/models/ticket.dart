import 'package:cloud_firestore/cloud_firestore.dart';

class Ticket {
  final String id;
  final String titre;
  final String description;
  final Timestamp creationDate;
  final Timestamp? resolvedDate;
  final String apprenant;
  final String? formateur;
  final dynamic reponses;

  Ticket({
    required this.id,
    required this.titre,
    required this.description,
    required this.creationDate,
    this.resolvedDate,
    required this.apprenant,
    this.formateur,
    this.reponses,
  });

  factory Ticket.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Ticket(
      id: doc.id,
      titre: data['titre'] ?? '',
      description: data['description'] ?? '',
      creationDate: data['creationDate'],
      resolvedDate: data['resolvedDate'],
      apprenant: data['apprenant'] ?? '',
      formateur: data['formateur'],
      reponses: data['reponses'],
    );
  }
}
