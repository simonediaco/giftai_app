import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Crea e configura una istanza Dio per le chiamate API
Dio createDioClient() {
  // URL base dell'API
  const String baseUrl = 'https://api.giftai.example.com';
  
  // In una vera app, questa verrebbe caricata da un file di configurazione o variabili d'ambiente
  const String apiVersion = 'v1';
  
  // Crea l'istanza di Dio con le opzioni base
  final dio = Dio(
    BaseOptions(
      baseUrl: '$baseUrl/$apiVersion',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );
  
  // Aggiungi gli interceptor
  dio.interceptors.add(_createAuthInterceptor());
  dio.interceptors.add(_createLoggingInterceptor());
  
  return dio;
}

/// Crea un interceptor per gestire l'autenticazione
Interceptor _createAuthInterceptor() {
  const storage = FlutterSecureStorage();
  
  return InterceptorsWrapper(
    onRequest: (options, handler) async {
      // Recupera il token di autenticazione dal secure storage
      final token = await storage.read(key: 'auth_token');
      
      // Se il token esiste, lo aggiunge all'header Authorization
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      
      return handler.next(options);
    },
    onError: (DioException error, handler) async {
      // Se riceviamo un 401 (Unauthorized), possiamo provare a refreshare il token
      if (error.response?.statusCode == 401) {
        try {
          // Recupera il refresh token
          final refreshToken = await storage.read(key: 'refresh_token');
          
          if (refreshToken != null) {
            // Crea un nuovo Dio per evitare loop infiniti
            final tokenDio = Dio();
            
            // Richiedi un nuovo token
            final response = await tokenDio.post(
              '${error.requestOptions.baseUrl}/auth/token/refresh/',
              data: {'refresh': refreshToken},
            );
            
            // Se abbiamo un nuovo token, aggiorniamo lo storage
            if (response.statusCode == 200) {
              await storage.write(key: 'auth_token', value: response.data['access']);
              
              // Ritenta la richiesta originale con il nuovo token
              final opts = error.requestOptions;
              opts.headers['Authorization'] = 'Bearer ${response.data['access']}';
              
              final newResponse = await tokenDio.fetch(opts);
              return handler.resolve(newResponse);
            }
          }
        } catch (e) {
          // In caso di errore durante il refresh, procediamo con l'errore originale
          print('Error refreshing token: $e');
        }
      }
      
      return handler.next(error);
    },
  );
}

/// Crea un interceptor per il logging
Interceptor _createLoggingInterceptor() {
  return InterceptorsWrapper(
    onRequest: (options, handler) {
      print('REQUEST[${options.method}] => PATH: ${options.path}');
      return handler.next(options);
    },
    onResponse: (response, handler) {
      print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
      return handler.next(response);
    },
    onError: (DioException error, handler) {
      print('ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}');
      return handler.next(error);
    },
  );
}

/// Funzione helper per verificare l'URL dell'API di destinazione
/// Utilizza questa funzione in fase di development per confermare
/// che stai contattando l'API corretta
Future<bool> checkApiConnection() async {
  final dio = Dio();
  try {
    final response = await dio.get('https://api.giftai.example.com/health-check');
    return response.statusCode == 200;
  } catch (e) {
    print('API Health Check Failed: $e');
    return false;
  }
}