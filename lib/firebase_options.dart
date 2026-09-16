// File generated for Firebase configuration
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        return android;
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBBTIK6K0GHu-ooCy0mUNGGpOydnVc78VU',
    appId: '1:666142223954:android:39f32e07d17d720e6e398b',
    messagingSenderId: '666142223954',
    projectId: 'kovera-coffee-app',
    storageBucket: 'kovera-coffee-app.firebasestorage.app',
  );
}
