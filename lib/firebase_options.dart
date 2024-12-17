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
        return macos;
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
    apiKey: 'AIzaSyBxrUvuI_-oh-hrWnxw2b-Y2H-Q-PBnLQg',
    appId: '1:511668633125:web:9ec84521c5eb201ace89cc',
    messagingSenderId: '511668633125',
    projectId: 'weather-8a55e',
    authDomain: 'weather-8a55e.firebaseapp.com',
    storageBucket: 'weather-8a55e.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD6QR_wcqqZUNl-XUMlV678qbiRdAjt3aw',
    appId: '1:511668633125:android:16bc67ec8bbcc812ce89cc',
    messagingSenderId: '511668633125',
    projectId: 'weather-8a55e',
    storageBucket: 'weather-8a55e.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB7voilmnbVfgeBc3NevwwCs14s-dtepg0',
    appId: '1:511668633125:ios:1068b9110922fd4bce89cc',
    messagingSenderId: '511668633125',
    projectId: 'weather-8a55e',
    storageBucket: 'weather-8a55e.firebasestorage.app',
    iosClientId: '511668633125-3ffa1nsi0pkjr64ol400g7bfq1cengjk.apps.googleusercontent.com',
    iosBundleId: 'com.example.weatherApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB7voilmnbVfgeBc3NevwwCs14s-dtepg0',
    appId: '1:511668633125:ios:1068b9110922fd4bce89cc',
    messagingSenderId: '511668633125',
    projectId: 'weather-8a55e',
    storageBucket: 'weather-8a55e.firebasestorage.app',
    iosClientId: '511668633125-3ffa1nsi0pkjr64ol400g7bfq1cengjk.apps.googleusercontent.com',
    iosBundleId: 'com.example.weatherApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBxrUvuI_-oh-hrWnxw2b-Y2H-Q-PBnLQg',
    appId: '1:511668633125:web:2953b84484b5d0cace89cc',
    messagingSenderId: '511668633125',
    projectId: 'weather-8a55e',
    authDomain: 'weather-8a55e.firebaseapp.com',
    storageBucket: 'weather-8a55e.firebasestorage.app',
  );

}