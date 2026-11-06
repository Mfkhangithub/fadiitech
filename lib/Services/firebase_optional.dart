// lib/firebase_options.dart
// GENERATED MANUALLY — paste your web app values into the TODO spots.
// If you prefer, run `flutterfire configure` to generate this file automatically.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      // *** IMPORTANT ***
      // You must create a Web app in Firebase Console (Project settings → Add app → Web)
      // and copy the web 'appId' and (optionally) 'measurementId' here.
      //
      // TODO: Replace the 'appId' and 'measurementId' values below with the ones shown
      // in Firebase Console for your web app. Until you do that, web auth may fail.
      return const FirebaseOptions(
          apiKey: "AIzaSyBnznde98xZMGDUxQNGoiBnVBvBJW0VDNE",
          authDomain: "fadiiwebport.firebaseapp.com",
          projectId: "fadiiwebport",
          storageBucket: "fadiiwebport.firebasestorage.app",
          messagingSenderId: "91563587026",
          appId: "1:91563587026:web:0a2a4a171e98d9c012c40b");
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        // Values taken from provided google-services.json
        return const FirebaseOptions(
            apiKey: "AIzaSyBnznde98xZMGDUxQNGoiBnVBvBJW0VDNE",
            authDomain: "fadiiwebport.firebaseapp.com",
            projectId: "fadiiwebport",
            storageBucket: "fadiiwebport.firebasestorage.app",
            messagingSenderId: "91563587026",
            appId: "1:91563587026:web:0a2a4a171e98d9c012c40b");
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        // If you add iOS / macOS apps in Firebase Console, replace these values accordingly.
        return const FirebaseOptions(
            apiKey: "AIzaSyBnznde98xZMGDUxQNGoiBnVBvBJW0VDNE",
            authDomain: "fadiiwebport.firebaseapp.com",
            projectId: "fadiiwebport",
            storageBucket: "fadiiwebport.firebasestorage.app",
            messagingSenderId: "91563587026",
            appId: "1:91563587026:web:0a2a4a171e98d9c012c40b");
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }
}

// import { initializeApp } from "firebase/app";
// import { getAnalytics } from "firebase/analytics";
// // TODO: Add SDKs for Firebase products that you want to use
// // https://firebase.google.com/docs/web/setup#available-libraries

// // Your web app's Firebase configuration
// // For Firebase JS SDK v7.20.0 and later, measurementId is optional
// const firebaseConfig = {
//   apiKey: "AIzaSyAXo0_BNiMbzj6stMB8RJV-Iqva9ikOj6Q",
//   authDomain: "productweb-3a95a.firebaseapp.com",
//   projectId: "productweb-3a95a",
//   storageBucket: "productweb-3a95a.firebasestorage.app",
//   messagingSenderId: "527989391527",
//   appId: "1:527989391527:web:59ee1893266a944f929b82",
//   measurementId: "G-YE8D1LTFH2"
// };
