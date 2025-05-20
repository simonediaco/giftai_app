import 'package:get_it/get_it.dart';
import 'package:giftai/repositories/auth_repository.dart';
import 'package:giftai/repositories/gift_repository.dart';
import 'package:giftai/repositories/recipient_repository.dart';
import 'package:giftai/repositories/history_repository.dart';
import 'package:giftai/services/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Servizi di base
  getIt.registerSingleton<ApiClient>(ApiClient());
  
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  
  // Repository
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepository(getIt<ApiClient>()));
  getIt.registerLazySingleton<GiftRepository>(() => GiftRepository(getIt<ApiClient>()));
  getIt.registerLazySingleton<RecipientRepository>(() => RecipientRepository(getIt<ApiClient>()));
  getIt.registerLazySingleton<HistoryRepository>(() => HistoryRepository(getIt<ApiClient>()));
}