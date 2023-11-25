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
    apiKey: 'AIzaSyAJ-oWZOD6Mh-eHJ--hRJW9jrklxjVDqN4',
    appId: '1:541209528339:android:8940d1617e040ffb7a97e6',
    messagingSenderId: '541209528339',
    projectId: 'scentia-396314',
    databaseURL: 'https://scentia-396314-default-rtdb.firebaseio.com',
    storageBucket: 'scentia-396314.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD30R8hZNNK32RAXTSgkQExGxXEQpIgwZM',
    appId: '1:541209528339:ios:b0266179b581b7697a97e6',
    messagingSenderId: '541209528339',
    projectId: 'scentia-396314',
    databaseURL: 'https://scentia-396314-default-rtdb.firebaseio.com',
    storageBucket: 'scentia-396314.appspot.com',
    androidClientId: '541209528339-4dvopt79n9kqsaoqtvek1i8cvn2v1ejr.apps.googleusercontent.com',
    iosClientId: '541209528339-c3htj43hd06s52ucl7fedmur6qano4j7.apps.googleusercontent.com',
    iosBundleId: 'com.example.cardTest',
  );
}
