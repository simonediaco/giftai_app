import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageUtils {
  final FlutterSecureStorage _storage;

  SecureStorageUtils(this._storage);

  // Token management
  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  Future<void> setAccessToken(String token) async {
    await _storage.write(key: 'access_token', value: token);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refresh_token');
  }

  Future<void> setRefreshToken(String token) async {
    await _storage.write(key: 'refresh_token', value: token);
  }

  Future<void> storeTokens({required String accessToken, required String refreshToken}) async {
    await _storage.write(key: 'access_token', value: accessToken);
    await _storage.write(key: 'refresh_token', value: refreshToken);
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
  }

  // User data caching
  Future<void> setUserId(String userId) async {
    await _storage.write(key: 'user_id', value: userId);
  }

  Future<String?> getUserId() async {
    return await _storage.read(key: 'user_id');
  }

  Future<void> clearUserData() async {
    await clearTokens();
    await _storage.delete(key: 'user_id');
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}