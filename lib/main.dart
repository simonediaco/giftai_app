import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'blocs/gift/gift_bloc.dart';
import 'core/api/api_client.dart';
import 'core/themes/app_theme.dart';
import 'repositories/gift_repository.dart';
import 'repositories/recipient_repository.dart';
import 'screens/gifts/quick_gift_generation_screen.dart';

void main() {
  // Configura Flutter Animate per animazioni fluide
  Animate.restartOnHotReload = true;
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Inizializza il client API
    final dio = Dio(BaseOptions(
      baseUrl: 'https://api.giftai.com', // Cambia con l'URL della tua API
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {'Content-Type': 'application/json'},
    ));

    // Aggiungi logging per debug
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));

    // Crea i repository
    final giftRepository = GiftRepository(dio);
    final recipientRepository = RecipientRepository(dio);

    return MultiBlocProvider(
      providers: [
        BlocProvider<GiftBloc>(
          create: (context) => GiftBloc(giftRepository: giftRepository),
        ),
      ],
      child: MaterialApp(
        title: 'GiftAI',
        theme: AppTheme.lightTheme(),
        darkTheme: AppTheme.darkTheme(),
        themeMode: ThemeMode.system, // Usa il tema di sistema (chiaro/scuro)
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('it'),
          Locale('en'),
        ],
        locale: const Locale('it'),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}

/// Schermata di Splash con animazioni
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    
    // Naviga alla schermata principale dopo un breve ritardo
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => 
            const QuickGiftGenerationScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo GiftAI
            Icon(
              Icons.card_giftcard,
              size: 120,
              color: theme.colorScheme.primary,
            )
            .animate()
            .fadeIn(duration: 600.ms, curve: Curves.easeOutQuad)
            .scale(
              begin: const Offset(0.5, 0.5),
              end: const Offset(1, 1),
              duration: 600.ms,
              curve: Curves.easeOutBack,
            ),
            
            const SizedBox(height: 24),
            
            // Testo "GiftAI"
            Text(
              'GiftAI',
              style: theme.textTheme.displayLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            )
            .animate()
            .fadeIn(
              duration: 600.ms, 
              delay: 300.ms,
              curve: Curves.easeOutQuad,
            )
            .slideY(
              begin: 0.3, 
              end: 0, 
              duration: 600.ms, 
              delay: 300.ms,
              curve: Curves.easeOutQuad,
            ),
            
            const SizedBox(height: 16),
            
            // Sottotitolo
            Text(
              'Idee regalo personalizzate',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.secondary,
              ),
            )
            .animate()
            .fadeIn(
              duration: 600.ms, 
              delay: 600.ms,
              curve: Curves.easeOutQuad,
            )
            .slideY(
              begin: 0.3, 
              end: 0, 
              duration: 600.ms, 
              delay: 600.ms,
              curve: Curves.easeOutQuad,
            ),
            
            const SizedBox(height: 64),
            
            // Indicatore di caricamento
            CircularProgressIndicator(
              color: theme.colorScheme.secondary,
            )
            .animate()
            .fadeIn(
              duration: 600.ms, 
              delay: 900.ms,
              curve: Curves.easeOutQuad,
            ),
          ],
        ),
      ),
    );
  }
}