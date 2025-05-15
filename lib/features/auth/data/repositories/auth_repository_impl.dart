import '../../../../core/errors/api_error.dart';
import '../../../../core/utils/secure_storage_utils.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorageUtils _secureStorage;
  
  AuthRepositoryImpl(this._remoteDataSource, this._secureStorage);
  
  @override
  Future<User> login({required String email, required String password}) async {
    try {
      final tokens = await _remoteDataSource.login(
        email: email, 
        password: password,
      );
      
      // Salva i token
      await _secureStorage.storeTokens(
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
      );
      
      // Ottieni le informazioni dell'utente
      final user = await _remoteDataSource.getCurrentUser();
      await _secureStorage.setUserId(user.id);
      
      return user;
    } catch (e) {
      rethrow;
    }
  }
  
  @override
  Future<User> register({
    required String email,
    required String password,
    required String username,
    String? name,
  }) async {
    try {
      final tokens = await _remoteDataSource.register(
        email: email,
        password: password,
        username: username,
        name: name,
      );
      
      // Salva i token
      await _secureStorage.storeTokens(
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
      );
      
      // Ottieni le informazioni dell'utente
      final user = await _remoteDataSource.getCurrentUser();
      await _secureStorage.setUserId(user.id);
      
      return user;
    } catch (e) {
      rethrow;
    }
  }
  
  @override
  Future<User?> getCurrentUser() async {
    try {
      final isLogged = await _secureStorage.isLoggedIn();
      if (!isLogged) {
        return null;
      }
      
      final user = await _remoteDataSource.getCurrentUser();
      return user;
    } on ApiError catch (e) {
      if (e.statusCode == 401) {
        await _secureStorage.clearTokens();
        return null;
      }
      rethrow;
    }
  }
  
  @override
  Future<void> logout() async {
    await _secureStorage.clearUserData();
  }
  
  @override
  Future<bool> isLoggedIn() async {
    return await _secureStorage.isLoggedIn();
  }
}