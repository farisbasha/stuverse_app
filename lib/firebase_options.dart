// 
//
//! API AND THIS FIREBASE APPS ARE NO LONGER WORKING
//
//
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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD0GAwn99YU7FY1LSG1peQKMqlkRFsUolI',
    appId: '1:199365110321:android:62edcf5f6cd6673f1bc310',
    messagingSenderId: '199365110321',
    projectId: 'stuverse-app',
    storageBucket: 'stuverse-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCQszNa2vDciOcm_8jXrXedjUpX8RG5lRc',
    appId: '1:199365110321:ios:9a4419e765d3a3301bc310',
    messagingSenderId: '199365110321',
    projectId: 'stuverse-app',
    storageBucket: 'stuverse-app.appspot.com',
    iosClientId: '199365110321-jikpcrds02lvke4tdsjlilmsr97j7llm.apps.googleusercontent.com',
    iosBundleId: 'com.example.stuverseApp',
  );
}
