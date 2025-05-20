import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giftai/blocs/auth/auth_bloc.dart';
import 'package:giftai/blocs/auth/auth_state.dart';
import 'package:giftai/screens/auth/login_screen.dart';
import 'package:giftai/screens/home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    
    // Naviga automaticamente dopo un ritardo se non succede nulla
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        final authState = context.read<AuthBloc>().state;
        if (authState is! AuthAuthenticated && authState is! AuthUnauthenticated) {
          // Se lo stato di autenticazione non è ancora determinato, naviga alla login
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          } else if (state is AuthUnauthenticated) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo animato
              Image.asset(
                'assets/images/splash_logo.png',
                width: 180,
                height: 180,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback se l'immagine non è disponibile
                  return const Icon(
                    Icons.card_giftcard,
                    size: 120,
                    color: Colors.purple,
                  );
                },
              ),
              
              const SizedBox(height: 30),
              
              // Testo animato
              const Text(
                'GiftAI',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 10),
              
              const Text(
                'La tua app per idee regalo perfette',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              
              const SizedBox(height: 60),
              
              // Loader animato
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}