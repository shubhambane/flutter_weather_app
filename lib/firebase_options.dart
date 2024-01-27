// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDpX6CKkuvwa03aLsIq1-8MpHVXmRBvY7c',
    appId: '1:264677790068:web:a56405407ce78a10e75c21',
    messagingSenderId: '264677790068',
    projectId: 'shubham-weather',
    authDomain: 'shubham-weather.firebaseapp.com',
    storageBucket: 'shubham-weather.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCBlXu4nuyf9hPQ5HOzDch1pwfbl6yrwhI',
    appId: '1:264677790068:android:2c8c1ceb0f02c270e75c21',
    messagingSenderId: '264677790068',
    projectId: 'shubham-weather',
    storageBucket: 'shubham-weather.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB7EPulYNxbn2Of9g9ikMxR9K0vSfjH_iM',
    appId: '1:264677790068:ios:95c753f204e714e4e75c21',
    messagingSenderId: '264677790068',
    projectId: 'shubham-weather',
    storageBucket: 'shubham-weather.appspot.com',
    iosBundleId: 'com.example.shubhamWeather',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB7EPulYNxbn2Of9g9ikMxR9K0vSfjH_iM',
    appId: '1:264677790068:ios:21e59c579a59409ae75c21',
    messagingSenderId: '264677790068',
    projectId: 'shubham-weather',
    storageBucket: 'shubham-weather.appspot.com',
    iosBundleId: 'com.example.shubhamWeather.RunnerTests',
  );
}
