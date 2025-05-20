// import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
// import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

// // NOTA: Questo è solo un file di esempio. 
// // Dovresti usare il file firebase_options.dart generato dal Firebase CLI.

// class DefaultFirebaseOptions {
//   static FirebaseOptions get currentPlatform {
//     switch (defaultTargetPlatform) {
//       case TargetPlatform.android:
//         return android;
//       case TargetPlatform.iOS:
//         return ios;
//       default:
//         throw UnsupportedError(
//           'DefaultFirebaseOptions are not supported for this platform.',
//         );
//     }
//   }

//   static const FirebaseOptions android = FirebaseOptions(
//     apiKey: 'AIzaSyBxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
//     appId: '1:123456789012:android:abcdefghijklmnopqrstuv',
//     messagingSenderId: '123456789012',
//     projectId: 'giftai-app',
//     storageBucket: 'giftai-app.appspot.com',
//   );

//   static const FirebaseOptions ios = FirebaseOptions(
//     apiKey: 'AIzaSyBxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
//     appId: '1:123456789012:ios:abcdefghijklmnopqrstuv',
//     messagingSenderId: '123456789012',
//     projectId: 'giftai-app',
//     storageBucket: 'giftai-app.appspot.com',
//     iosClientId: 'com.googleusercontent.apps.123456789012-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
//     iosBundleId: 'com.giftai.app',
//   );
// }