import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/navigation/main_layout.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'login_page.dart';
import '../../../../features/home/presentation/pages/home_page.dart';

class SplashPage extends StatefulWidget {
  static const routeName = '/splash';
  
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    
    _controller.forward();
    
    // Check auth status after animation
    Future.delayed(const Duration(seconds: 2), () {
      context.read<AuthBloc>().add(AuthCheckRequested());
    });
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.of(context).pushReplacementNamed(MainLayout.routeName);
          } else if (state is Unauthenticated) {
            Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo dell'app
              Image.asset(
                'assets/images/logo-02.png',
                width: 120,
                height: 120,
              ),
              const SizedBox(height: AppTheme.spaceL),
              // Nome dell'app
              Text(
                'GiftAI',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: AppTheme.spaceL),
              // Animazione di caricamento
              SizedBox(
                width: 100,
                height: 100,
                child: Lottie.asset(
                  'assets/animations/loading.json',
                  controller: _controller,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}