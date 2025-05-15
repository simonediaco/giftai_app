import 'package:dio/dio.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/errors/api_error.dart';
import '../models/auth_tokens.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthTokens> login({required String email, required String password});
  Future<AuthTokens> register({required String email, required String password, String? name, required String username});
  Future<UserModel> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;
  
  AuthRemoteDataSourceImpl(this._apiClient);
  
  @override
  Future<AuthTokens> login({required String email, required String password}) async {
    try {
      final response = await _apiClient.post(
        '/api/auth/token/',
        data: {
          'email': email,
          'password': password,
        },
      );
      return AuthTokens.fromJson(response.data);
    } on ApiError {
      rethrow;
    } catch (e) {
      throw ApiError(
        message: 'Si è verificato un errore durante il login',
        statusCode: 500,
      );
    }
  }
  
  @override
  Future<AuthTokens> register({
    required String email,
    required String password,
    required String username,
    String? name,
  }) async {
    try {
      await _apiClient.post(
        '/api/auth/register/',
        data: {
          'email': email,
          'username': username,
          'password': password,
          'password_confirm': password,
          'name': name,
        },
      );
      
      return await login(email: email, password: password);
    } on ApiError {
      rethrow;
    } catch (e) {
      throw ApiError(
        message: 'Si è verificato un errore durante la registrazione',
        statusCode: 500,
      );
    }
  }
  
  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _apiClient.get('/api/users/me/');
      return UserModel.fromJson(response.data);
    } on ApiError {
      rethrow;
    } catch (e) {
      throw ApiError(
        message: 'Si è verificato un errore durante il recupero del profilo',
        statusCode: 500,
      );
    }
  }
}