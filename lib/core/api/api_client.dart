import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Singleton class for API client configuration and initialization
class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late Dio dio;
  
  // Base URL for API
  static const String baseUrl = 'https://giftai-api.example.com';
  
  // Secure storage for token
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  factory ApiClient() {
    return _instance;
  }

  ApiClient._internal() {
    _initDio();
  }

  /// Initialize Dio with base configuration and interceptors
  Future<void> _initDio() async {
    // Base options
    final BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    );

    dio = Dio(options);

    // Add interceptors
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));

    // Add auth interceptor
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Get token from secure storage
        final token = await _secureStorage.read(key: 'auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Token $token';
        }
        return handler.next(options);
      },
      onError: (DioException error, handler) {
        print('API Error: ${error.message}');
        // Handle specific error codes
        if (error.response?.statusCode == 401) {
          // Handle unauthorized error
          print('Unauthorized access. Token may be expired.');
          // You could trigger a logout or token refresh here
        }
        return handler.next(error);
      },
    ));
  }

  /// Get Dio instance for API calls
  Dio getDio() {
    return dio;
  }

  /// Update auth token
  Future<void> setAuthToken(String token) async {
    await _secureStorage.write(key: 'auth_token', value: token);
  }

  /// Clear auth token (for logout)
  Future<void> clearAuthToken() async {
    await _secureStorage.delete(key: 'auth_token');
  }
}