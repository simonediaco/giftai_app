import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/config/app_config.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/auth/presentation/pages/splash_page.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'shared/di/injection.dart';
import 'features/gift_ideas/presentation/pages/gift_generation_page.dart';
import 'features/gift_ideas/presentation/bloc/gift_ideas_bloc.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inizializza la configurazione dell'app
  AppConfig(
    apiBaseUrl: 'http://localhost:8000', // Aggiungi http:// prima dell'URL
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
        // Altri BlocProvider verranno aggiunti qui
      ],
      child: MaterialApp(
        title: 'GiftAI',
        theme: AppTheme.lightTheme(),
        darkTheme: AppTheme.darkTheme(),
        themeMode: ThemeMode.system,
        initialRoute: SplashPage.routeName,
        routes: {
          SplashPage.routeName: (context) => const SplashPage(),
          LoginPage.routeName: (context) => const LoginPage(),
          RegisterPage.routeName: (context) => const RegisterPage(),
          HomePage.routeName: (context) => const HomePage(),
          GiftGenerationPage.routeName: (context) => const GiftGenerationPage(),
        },
      ),
    );
  }
}