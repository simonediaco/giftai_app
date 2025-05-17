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

import '../../features/gift_ideas/data/datasources/gift_ideas_remote_data_source.dart';
import '../../features/gift_ideas/data/repositories/gift_ideas_repository_impl.dart';
import '../../features/gift_ideas/domain/repositories/gift_ideas_repository.dart';
import '../../features/gift_ideas/domain/usecases/generate_gift_ideas.dart';
import '../../features/gift_ideas/presentation/bloc/gift_ideas_bloc.dart';

import '../../features/saved_gifts/data/datasources/saved_gifts_remote_data_source.dart';
import '../../features/saved_gifts/data/repositories/saved_gifts_repository_impl.dart';
import '../../features/saved_gifts/domain/repositories/saved_gifts_repository.dart';
import '../../features/saved_gifts/domain/usecases/get_saved_gifts.dart';
import '../../features/saved_gifts/domain/usecases/save_gift.dart';
import '../../features/saved_gifts/domain/usecases/delete_saved_gift.dart';
import '../../features/saved_gifts/presentation/bloc/saved_gifts_bloc.dart';

import '../../features/recipients/data/datasources/recipients_remote_data_source.dart';
import '../../features/recipients/data/repositories/recipients_repository_impl.dart';
import '../../features/recipients/domain/repositories/recipients_repository.dart';
import '../../features/recipients/domain/usecases/create_recipient.dart';
import '../../features/recipients/domain/usecases/delete_recipient.dart';
import '../../features/recipients/domain/usecases/get_recipient.dart';
import '../../features/recipients/domain/usecases/get_recipients.dart';
import '../../features/recipients/domain/usecases/update_recipient.dart';
import '../../features/recipients/presentation/bloc/recipients_bloc.dart';

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
  
  // Gift Ideas Feature
  getIt.registerSingleton<GiftIdeasRemoteDataSource>(
    GiftIdeasRemoteDataSourceImpl(getIt<ApiClient>()),
  );

  getIt.registerSingleton<GiftIdeasRepository>(
    GiftIdeasRepositoryImpl(getIt<GiftIdeasRemoteDataSource>()),
  );

  getIt.registerSingleton<GenerateGiftIdeas>(
    GenerateGiftIdeas(getIt<GiftIdeasRepository>()),
  );

  getIt.registerFactory<GiftIdeasBloc>(
    () => GiftIdeasBloc(
      generateGiftIdeas: getIt<GenerateGiftIdeas>(),
    ),
  );
  
  // Saved Gifts Feature
  getIt.registerSingleton<SavedGiftsRemoteDataSource>(
    SavedGiftsRemoteDataSourceImpl(getIt<ApiClient>()),
  );

  getIt.registerSingleton<SavedGiftsRepository>(
    SavedGiftsRepositoryImpl(getIt<SavedGiftsRemoteDataSource>()),
  );

  getIt.registerSingleton<GetSavedGifts>(
    GetSavedGifts(getIt<SavedGiftsRepository>()),
  );

  getIt.registerSingleton<SaveGift>(
    SaveGift(getIt<SavedGiftsRepository>()),
  );

  getIt.registerSingleton<DeleteSavedGift>(
    DeleteSavedGift(getIt<SavedGiftsRepository>()),
  );

  getIt.registerFactory<SavedGiftsBloc>(
    () => SavedGiftsBloc(
      getSavedGifts: getIt<GetSavedGifts>(),
      saveGift: getIt<SaveGift>(),
      deleteSavedGift: getIt<DeleteSavedGift>(),
    ),
  );

  // Recipients Feature
  getIt.registerSingleton<RecipientsRemoteDataSource>(
    RecipientsRemoteDataSourceImpl(getIt<ApiClient>()),
  );

  getIt.registerSingleton<RecipientsRepository>(
    RecipientsRepositoryImpl(getIt<RecipientsRemoteDataSource>()),
  );

  getIt.registerSingleton<GetRecipients>(
    GetRecipients(getIt<RecipientsRepository>()),
  );

  getIt.registerSingleton<GetRecipient>(
    GetRecipient(getIt<RecipientsRepository>()),
  );

  getIt.registerSingleton<CreateRecipient>(
    CreateRecipient(getIt<RecipientsRepository>()),
  );

  getIt.registerSingleton<UpdateRecipient>(
    UpdateRecipient(getIt<RecipientsRepository>()),
  );

  getIt.registerSingleton<DeleteRecipient>(
    DeleteRecipient(getIt<RecipientsRepository>()),
  );

  getIt.registerFactory<RecipientsBloc>(
    () => RecipientsBloc(
      getRecipients: getIt<GetRecipients>(),
      getRecipient: getIt<GetRecipient>(),
      createRecipient: getIt<CreateRecipient>(),
      updateRecipient: getIt<UpdateRecipient>(),
      deleteRecipient: getIt<DeleteRecipient>(),
    ),
  );
  // Altri registri verranno aggiunti man mano che implementiamo le features
}