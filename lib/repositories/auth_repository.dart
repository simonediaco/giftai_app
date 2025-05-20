import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:giftai/config/app_config.dart';
import 'package:giftai/models/user_model.dart';
import 'package:giftai/services/api_client.dart';

class AuthRepository {
  final ApiClient _apiClient;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  AuthRepository(this._apiClient);

  // Registrazione nuovo utente
  Future<bool> register({
    required String username,
    required String email,
    required String password,
    required String passwordConfirm,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final response = await _apiClient.post(
        AppConfig.registerEndpoint,
        data: {
          'username': username,
          'email': email,
          'password': password,
          'password_confirm': passwordConfirm,
          'first_name': firstName,
          'last_name': lastName,
        },
      );
      
      return response.statusCode == 201;
    } catch (e) {
      rethrow;
    }
  }

  // Login utente
  Future<bool> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        AppConfig.loginEndpoint,
        data: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        await _secureStorage.write(key: 'jwt_token', value: response.data['access']);
        await _secureStorage.write(key: 'jwt_refresh_token', value: response.data['refresh']);
        return true;
      }
      
      return false;
    } catch (e) {
      rethrow;
    }
  }

  // Logout utente
  Future<void> logout() async {
    await _secureStorage.delete(key: 'jwt_token');
    await _secureStorage.delete(key: 'jwt_refresh_token');
  }

  // Verifica se l'utente è loggato
  Future<bool> isLoggedIn() async {
    final token = await _secureStorage.read(key: 'jwt_token');
    return token != null;
  }

  // Ottieni dati utente
  Future<UserModel?> getUserProfile() async {
    try {
      final response = await _apiClient.get(AppConfig.userProfileEndpoint);
      
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  // Aggiorna profilo utente
  Future<bool> updateUserProfile({
    String? firstName,
    String? lastName,
    String? bio,
    String? avatar,
    String? phoneNumber,
  }) async {
    try {
      final profileData = {
        'bio': bio,
        'avatar': avatar,
        'phone_number': phoneNumber,
      }..removeWhere((key, value) => value == null);

      final data = {
        'first_name': firstName,
        'last_name': lastName,
        'profile': profileData,
      }..removeWhere((key, value) => value == null);

      final response = await _apiClient.patch(
        '/api/users/update_profile/',
        data: data,
      );
      
      return response.statusCode == 200;
    } catch (e) {
      rethrow;
    }
  }
}