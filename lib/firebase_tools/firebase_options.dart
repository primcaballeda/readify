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
    apiKey: 'AIzaSyAHovvrb2oGQ1NO0kDpnKHRNojcQK-AF-I',
    appId: '1:651435724951:web:23a1bf9a903acb2e0a59d2',
    messagingSenderId: '651435724951',
    projectId: 'testdemo-3439c',
    authDomain: 'testdemo-3439c.firebaseapp.com',
    storageBucket: 'testdemo-3439c.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBryOXUXVmT5l0glA0_No1_YxFb9tKF8D4',
    appId: '1:651435724951:android:c892c1749d3c73370a59d2',
    messagingSenderId: '651435724951',
    projectId: 'testdemo-3439c',
    storageBucket: 'testdemo-3439c.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC_gSeEWhMhFlaHwmI3Rs8D8owaV29xras',
    appId: '1:651435724951:ios:03d3c809710e53a70a59d2',
    messagingSenderId: '651435724951',
    projectId: 'testdemo-3439c',
    storageBucket: 'testdemo-3439c.firebasestorage.app',
    iosBundleId: 'com.example.readify',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC_gSeEWhMhFlaHwmI3Rs8D8owaV29xras',
    appId: '1:651435724951:ios:03d3c809710e53a70a59d2',
    messagingSenderId: '651435724951',
    projectId: 'testdemo-3439c',
    storageBucket: 'testdemo-3439c.firebasestorage.app',
    iosBundleId: 'com.example.readify',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAHovvrb2oGQ1NO0kDpnKHRNojcQK-AF-I',
    appId: '1:651435724951:web:5f072018f3977b3f0a59d2',
    messagingSenderId: '651435724951',
    projectId: 'testdemo-3439c',
    authDomain: 'testdemo-3439c.firebaseapp.com',
    storageBucket: 'testdemo-3439c.firebasestorage.app',
  );
}