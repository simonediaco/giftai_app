import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config/app_config.dart';
import '../utils/secure_storage_utils.dart';
import '../errors/api_error.dart';

class ApiClient {
  late Dio _dio;
  final SecureStorageUtils _secureStorage;

  ApiClient(this._secureStorage) {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.instance.apiBaseUrl,
        connectTimeout: const Duration(milliseconds: 15000),
        receiveTimeout: const Duration(milliseconds: 15000),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    if (AppConfig.instance.enableLogging) {
      _dio.interceptors.add(LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ));
    }

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add JWT token to requests if available
          final token = await _secureStorage.getAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            // Token expired, try to refresh
            try {
              final refreshed = await _refreshToken();
              if (refreshed) {
                // Retry original request
                final token = await _secureStorage.getAccessToken();
                final opts = Options(
                  method: e.requestOptions.method,
                  headers: {...e.requestOptions.headers, 'Authorization': 'Bearer $token'},
                );

                final response = await _dio.request(
                  e.requestOptions.path,
                  options: opts,
                  data: e.requestOptions.data,
                  queryParameters: e.requestOptions.queryParameters,
                );
                return handler.resolve(response);
              }
            } catch (refreshError) {
              // Refresh failed, logout user
              await _secureStorage.clearTokens();
              return handler.reject(e);
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  Future<bool> _refreshToken() async {
    final refreshToken = await _secureStorage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      return false;
    }

    try {
      final response = await _dio.post(
        '/api/auth/token/refresh/',
        data: {'refresh': refreshToken},
      );

      if (response.statusCode == 200) {
        await _secureStorage.setAccessToken(response.data['access']);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Metodi wrapper per le chiamate API
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw ApiError.fromDioError(e);
    } catch (e) {
      throw ApiError(
        message: 'Si è verificato un errore imprevisto',
        statusCode: 500,
      );
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw ApiError.fromDioError(e);
    } catch (e) {
      throw ApiError(
        message: 'Si è verificato un errore imprevisto',
        statusCode: 500,
      );
    }
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw ApiError.fromDioError(e);
    } catch (e) {
      throw ApiError(
        message: 'Si è verificato un errore imprevisto',
        statusCode: 500,
      );
    }
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw ApiError.fromDioError(e);
    } catch (e) {
      throw ApiError(
        message: 'Si è verificato un errore imprevisto',
        statusCode: 500,
      );
    }
  }
}