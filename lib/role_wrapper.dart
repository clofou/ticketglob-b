import 'package:flutter/material.dart';
import 'package:ticketglob/screens/Admin/admin_dashboard.dart';
import 'package:ticketglob/screens/Apprenants/home/apprenant_home.dart';
import 'package:ticketglob/screens/Formateurs/home/formateur_home.dart';
import 'package:ticketglob/services/db_service.dart';

class RoleWrapper extends StatelessWidget {
  final String useruid;
  const RoleWrapper({super.key, required this.useruid});


@override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>?>(
      stream: DbService().getRealtimeData("users", useruid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text("No data available"));
        } else {
          final data = snapshot.data!;
          if(data["role"] == "APPRENANT"){
            return const ApprenantHome();
          }else if(data["role"] == "FORMATEUR"){
            return const FormateurHome();
          } else {
            return const AdminDashboard();
          }
        }
      },
    );
  }
}