import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giftai/blocs/auth/auth_bloc.dart';
import 'package:giftai/blocs/auth/auth_event.dart';
import 'package:giftai/blocs/gift/gift_bloc.dart';
import 'package:giftai/blocs/history/history_bloc.dart';
import 'package:giftai/blocs/recipient/recipient_bloc.dart';
import 'package:giftai/screens/auth/splash_screen.dart';
import 'package:giftai/services/firebase_service.dart';
import 'package:giftai/services/service_locator.dart';
import 'package:giftai/themes/app_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inizializza il service locator
  await setupServiceLocator();
  
  // Inizializza Firebase
  // try {
  //   await FirebaseService.initialize();
  //   print('Firebase inizializzato con successo');
  // } catch (e) {
  //   print('Errore nell\'inizializzazione di Firebase: $e');
  //   print('L\'app continuerà senza le funzionalità Firebase');
  // }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            authRepository: getIt.get(),
          )..add(AuthCheckRequested()),
        ),
        BlocProvider<RecipientBloc>(
          create: (context) => RecipientBloc(
            recipientRepository: getIt.get(),
          ),
        ),
        BlocProvider<GiftBloc>(
          create: (context) => GiftBloc(
            giftRepository: getIt.get(),
          ),
        ),
        BlocProvider<HistoryBloc>(
          create: (context) => HistoryBloc(
            historyRepository: getIt.get(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'GiftAI',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('it', 'IT'),
          Locale('en', 'US'),
        ],
        home: const SplashScreen(),
      ),
    );
  }
}