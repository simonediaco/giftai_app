// lib/main.dart (aggiornato)
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/config/app_config.dart';
import 'core/theme/app_theme.dart';
import 'core/navigation/main_layout.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/auth/presentation/pages/splash_page.dart';
import 'features/gift_ideas/presentation/bloc/gift_ideas_bloc.dart';
import 'features/gift_ideas/presentation/pages/gift_wizard_page.dart';
import 'features/saved_gifts/presentation/bloc/saved_gifts_bloc.dart';
import 'shared/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inizializza la configurazione dell'app
  AppConfig(
    apiBaseUrl: 'http://localhost:8000', // Aggiornato con http://
    environment: Environment.dev,
    enableLogging: true,
  );
  
  // Inizializza le dipendenze
  await initializeDependencies();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => getIt<AuthBloc>(),
        ),
        BlocProvider<GiftIdeasBloc>(
          create: (context) => getIt<GiftIdeasBloc>(),
        ),
        BlocProvider<SavedGiftsBloc>(
          create: (context) => getIt<SavedGiftsBloc>(),
        ),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Unauthenticated) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              LoginPage.routeName,
              (route) => false,
            );
          }
        },
        child: MaterialApp(
          title: 'GiftAI',
          theme: AppTheme.lightTheme(),
          darkTheme: AppTheme.darkTheme(),
          themeMode: ThemeMode.system,
          debugShowCheckedModeBanner: false,
          initialRoute: SplashPage.routeName,
          routes: {
            SplashPage.routeName: (context) => const SplashPage(),
            LoginPage.routeName: (context) => const LoginPage(),
            RegisterPage.routeName: (context) => const RegisterPage(),
            MainLayout.routeName: (context) => const MainLayout(),
            GiftWizardPage.routeName: (context) => const GiftWizardPage(),
          },
        ),
      ),
    );
  }
}