import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/api/api_client.dart';
import '../../core/config/app_config.dart';
import '../../core/utils/secure_storage_utils.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_current_user.dart';
import '../../features/auth/domain/usecases/login.dart';
import '../../features/auth/domain/usecases/logout.dart';
import '../../features/auth/domain/usecases/register.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

final getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  // Core
  final preferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(preferences);
  
  getIt.registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());
  
  getIt.registerSingleton<SecureStorageUtils>(
    SecureStorageUtils(getIt<FlutterSecureStorage>()),
  );
  
  getIt.registerSingleton<ApiClient>(
    ApiClient(getIt<SecureStorageUtils>()),
  );
  
  // Auth Feature
  getIt.registerSingleton<AuthRemoteDataSource>(
    AuthRemoteDataSourceImpl(getIt<ApiClient>()),
  );
  
  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(
      getIt<AuthRemoteDataSource>(),
      getIt<SecureStorageUtils>(),
    ),
  );
  
  // Auth UseCases
  getIt.registerSingleton<Login>(
    Login(getIt<AuthRepository>()),
  );
  
  getIt.registerSingleton<Register>(
    Register(getIt<AuthRepository>()),
  );
  
  getIt.registerSingleton<Logout>(
    Logout(getIt<AuthRepository>()),
  );
  
  getIt.registerSingleton<GetCurrentUser>(
    GetCurrentUser(getIt<AuthRepository>()),
  );
  
  // Auth Bloc
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(
      login: getIt<Login>(),
      register: getIt<Register>(),
      logout: getIt<Logout>(),
      getCurrentUser: getIt<GetCurrentUser>(),
    ),
  );
  
  // Altri registri verranno aggiunti man mano che implementiamo le features
}