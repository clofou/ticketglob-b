import 'package:flutter/material.dart';
import 'package:ticketglob/models/users_data.dart';

class UserDataSource extends DataTableSource {
  final List<UserData> users;
  final Color Function(String role) getRoleColor;

  UserDataSource({required this.users, required this.getRoleColor});

  @override
  DataRow getRow(int index) {
    final user = users[index];

    return DataRow.byIndex(index: index, cells: [
      DataCell(Text(
          '${user.creationDate.day}/${user.creationDate.month}/${user.creationDate.year}')),
      DataCell(Text(user.uid)),
      DataCell(Text(user.email)),
      DataCell(Text(user.nomComplet)),
      DataCell(Text(
          '${user.lastSignInDate.day}/${user.lastSignInDate.month}/${user.lastSignInDate.year}')),
      DataCell(
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: getRoleColor(user.role),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(user.role),
        ),
      ),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => users.length;

  @override
  int get selectedRowCount => 0;

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}