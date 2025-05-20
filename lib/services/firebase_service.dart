// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
// // Rimuovi l'import di firebase_messaging
// import 'package:flutter/material.dart';

// class FirebaseService {
//   static late FirebaseAnalytics analytics;
//   // Rimuovi la variabile messaging
  
//   static Future<void> initialize() async {
//     await Firebase.initializeApp();
    
//     // Inizializza Analytics
//     analytics = FirebaseAnalytics.instance;
    
//     // Rimuovi tutta la sezione relativa a Messaging
//   }
  
//   // Metodo per tracciare eventi
//   static void logEvent({
//     required String name,
//     Map<String, dynamic>? parameters,
//   }) {
//     analytics.logEvent(
//       name: name,
//       parameters: parameters,
//     );
//   }
  
//   // Metodo per tracciare schermata corrente
//   static void setCurrentScreen(String screenName) {
//     analytics.setCurrentScreen(screenName: screenName);
//   }
  
//   // Modifica questo metodo per non usare messaging
//   static Future<String?> getToken() async {
//     // Ritorna null o un valore fittizio poiché non stiamo usando messaging
//     return null;
//   }
// }