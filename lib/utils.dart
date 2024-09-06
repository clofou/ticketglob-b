import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppColors {
  static const MaterialColor primarySwatch = MaterialColor(
    0xFF058C42, // Couleur principale
    <int, Color>{
      50: Color(0xFFE0F2E9),
      100: Color(0xFFB3DEC7),
      200: Color(0xFF80C9A2),
      300: Color(0xFF4DB47C),
      400: Color(0xFF26A85E),
      500: Color(0xFF058C42), // La couleur principale
      600: Color(0xFF04803B),
      700: Color(0xFF037130),
      800: Color(0xFF026226),
      900: Color(0xFF014517),
    },
  );

  static const Color accentColor = Color(0xFF8F9098);
  static const Color backgroundColor = Color(0xFFF7F7F7);
  static const Color textColor = Color.fromARGB(255, 24, 24, 24);
}

class AppTextStyles {
  static const TextStyle headline1 = TextStyle(
    fontFamily: "Poppins",
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textColor,
  );

  static const TextStyle headline2 = TextStyle(
    fontFamily: "Nunito",
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textColor,
  );

  static const TextStyle bodyText3 = TextStyle(
    fontFamily: "Inter",
    fontSize: 18.0,
    color: AppColors.textColor,
  );

  static const TextStyle bodyText1 = TextStyle(
    fontFamily: "Inter",
    fontSize: 16.0,
    color: AppColors.textColor,
  );

  static const TextStyle bodyText2 = TextStyle(
    fontFamily: "Inter",
    fontSize: 14.0,
    color: AppColors.textColor,
  );
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primarySwatch: AppColors.primarySwatch,
    primaryColor: AppColors.primarySwatch,
    useMaterial3: true,
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: AppColors.primarySwatch,
      accentColor: AppColors.primarySwatch[300],
      cardColor: Colors.white,
      errorColor: Colors.red,
    ),
    textTheme: const TextTheme(
      titleLarge: AppTextStyles.headline1,
      titleMedium: AppTextStyles.headline2,
      bodyLarge: AppTextStyles.bodyText3,
      bodyMedium: AppTextStyles.bodyText1,
      bodySmall: AppTextStyles.bodyText2,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: AppColors.primarySwatch[500],
      textTheme: ButtonTextTheme.primary,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primarySwatch[500],
      titleTextStyle: AppTextStyles.headline2.copyWith(color: Colors.white),
    ),
  );
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppColors.primarySwatch[500],
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        textStyle: AppTextStyles.bodyText1.copyWith(color: Colors.white),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

class AppSpacing {
  static const double small = 8.0;
  static const double medium = 16.0;
  static const double large = 24.0;
}

class AppIcons {
  static const IconData home = Icons.explore;
  static const IconData message = Icons.message;
  static const IconData tickets = Icons.confirmation_num;
  static const IconData profil = Icons.person;
  static const IconData logout = Icons.logout;
  static const IconData receipt = Icons.receipt_long;
  static const IconData group = Icons.group;
  static const IconData search = Icons.search;
  static const IconData notif = Icons.notifications;
  static const IconData add = Icons.add;
  static const IconData mail = Icons.mail;
  static const IconData visible = Icons.visibility;
  static const IconData visibilityoff = Icons.visibility_off;
  static const IconData password = Icons.password;
  static const IconData call = Icons.call;
  static const IconData theorique = Icons.contact_support;
  static const IconData pratique = Icons.build;
  static const IconData teacher = Icons.badge;
  static const IconData admin = Icons.admin_panel_settings;
  static const IconData sort = Icons.sort;
  static const IconData app = Icons.apps;
  static const IconData reorder = Icons.reorder;
}

class AppGlobal {
  static inputDecoration(BuildContext context, {String? hintText}) =>
      InputDecoration(
          enabledBorder:
              const OutlineInputBorder(borderSide: BorderSide(width: 0.5)),
          hintText: hintText,
          hintStyle: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: AppColors.accentColor),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))));
  static snackdemo({required String message, Color? backgroundColor}) =>
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: backgroundColor,
        elevation: 10,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(5),
      );
}

class AppFunction {
  static bool isValidEmail(String email) {
    // Définition de l'expression régulière pour valider l'email
    String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(emailPattern);

    // Retourne true si l'email correspond au pattern, false sinon
    return regex.hasMatch(email);
  }

  static bool isValidInternationalPhoneNumber(String phoneNumber) {
  // Définition de l'expression régulière pour valider le numéro de téléphone international
  String phonePattern = r'^\+\d{1,3}\s?\d{1,14}(\s?\d{1,13})?$';
  RegExp regex = RegExp(phonePattern);
  
  // Retourne true si le numéro correspond au pattern, false sinon
  return regex.hasMatch(phoneNumber);
}

static String formatDate(DateTime date) {
    // Define the desired format
    final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm:ss');
    // Format the date
    return formatter.format(date);
  }
}
