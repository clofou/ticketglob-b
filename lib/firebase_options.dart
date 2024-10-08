// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAb-szW3wTKPCMGAXOgoHroh5R4a8HuyOw',
    appId: '1:664725274473:web:d715235109be38420307f8',
    messagingSenderId: '664725274473',
    projectId: 'ticketglob',
    authDomain: 'ticketglob.firebaseapp.com',
    storageBucket: 'ticketglob.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBPPZf5JFJMlu6TUZdFKJfIZzPNc-USql8',
    appId: '1:664725274473:android:b68feebc8803fdc10307f8',
    messagingSenderId: '664725274473',
    projectId: 'ticketglob',
    storageBucket: 'ticketglob.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD5l9bwHGMe7cM7w9939TkKAMORvtIX9qg',
    appId: '1:664725274473:ios:83ed67908e1884150307f8',
    messagingSenderId: '664725274473',
    projectId: 'ticketglob',
    storageBucket: 'ticketglob.appspot.com',
    iosBundleId: 'com.example.ticketglob',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAb-szW3wTKPCMGAXOgoHroh5R4a8HuyOw',
    appId: '1:664725274473:web:b0eb7cb7ac469f220307f8',
    messagingSenderId: '664725274473',
    projectId: 'ticketglob',
    authDomain: 'ticketglob.firebaseapp.com',
    storageBucket: 'ticketglob.appspot.com',
  );
}
