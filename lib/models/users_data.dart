class UserData {
  final String uid;
  final String email;
  final String nomComplet;
  final String role;
  final String telephone;
  final DateTime creationDate;
  final DateTime lastSignInDate;

  UserData({
    required this.uid,
    required this.email,
    required this.nomComplet,
    required this.role,
    required this.creationDate,
    required this.lastSignInDate,
    required this.telephone, 
  });
}