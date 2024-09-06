import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:ticketglob/role_wrapper.dart';
import 'package:ticketglob/screens/Admin/admin_dashboard.dart';
import 'package:ticketglob/screens/connexion/connexion_screen.dart';
import 'package:ticketglob/services/auth_service.dart';
import 'package:ticketglob/utils.dart';
import 'package:ticketglob/wrapper.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(
    MultiProvider(
      providers: [
        StreamProvider.value(value: AuthService().user, initialData: null)
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TicketGlob',
      theme: AppTheme.lightTheme,
      home: const Splash(),
    );
  }
}

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    super.initState();
    initialization();
  }

  initialization() async {
    await Future.delayed(const Duration(seconds: 3));
    FlutterNativeSplash.remove();
  }


  @override
  Widget build(BuildContext context) {
    return const ConnexionScreen();
  }
  
}
