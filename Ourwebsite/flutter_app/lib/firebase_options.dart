// ignore_for_file: lines_longer_than_80_chars

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Firebase configuration generated manually from the provided web configuration.
///
/// For mobile platforms, update the corresponding [FirebaseOptions] once the
/// platform-specific Firebase apps are created.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    throw UnsupportedError(
      'DefaultFirebaseOptions are only configured for web. Run flutterfire configure for other platforms.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD24uQNUWsuvn3r6PZAkvDqUPOheQKhY7Q',
    appId: '1:351109835631:web:41784c5a83f3d57f97969a',
    messagingSenderId: '351109835631',
    projectId: 'ourwebsite-44a4d',
    authDomain: 'ourwebsite-44a4d.firebaseapp.com',
    storageBucket: 'ourwebsite-44a4d.firebasestorage.app',
  );
}

