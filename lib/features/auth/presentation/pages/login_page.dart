import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'register_page.dart';
import '../../../../features/home/presentation/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';
  
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            LoginRequested(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.of(context).pushReplacementNamed(HomePage.routeName);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spaceL),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo e Titolo
                    Image.asset(
                      'assets/images/logo.png',
                      height: 100,
                      width: 100,
                    ),
                    const SizedBox(height: AppTheme.spaceL),
                    Text(
                      'Benvenuto in GiftAI',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppTheme.spaceM),
                    Text(
                      'Accedi per trovare il regalo perfetto',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppTheme.spaceXL),
                    
                    // Form di Login
                    AppTextField(
                      label: 'Email',
                      hint: 'Inserisci la tua email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Inserisci la tua email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Inserisci un\'email valida';
                        }
                        return null;
                      },
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                    const SizedBox(height: AppTheme.spaceL),
                    AppTextField(
                      label: 'Password',
                      hint: 'Inserisci la tua password',
                      controller: _passwordController,
                      obscureText: !_passwordVisible,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Inserisci la tua password';
                        }
                        if (value.length < 6) {
                          return 'La password deve contenere almeno 6 caratteri';
                        }
                        return null;
                      },
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: AppTheme.spaceM),
                    
                    // Pulsante Password Dimenticata
                    Align(
                      alignment: Alignment.centerRight,
                      child: AppButton(
                        text: 'Password dimenticata?',
                        type: AppButtonType.text,
                        onPressed: () {
                          // TODO: Implementare recupero password
                        },
                      ),
                    ),
                    const SizedBox(height: AppTheme.spaceXL),
                    
                    // Pulsante Login
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return AppButton(
                          text: 'Accedi',
                          isLoading: state is AuthLoading,
                          onPressed: _login,
                        );
                      },
                    ),
                    const SizedBox(height: AppTheme.spaceL),
                    
                    // Oppure divider
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceM),
                          child: Text(
                            'oppure',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spaceL),
                    
                    // Pulsante generazione veloce
                    AppButton(
                      text: 'Genera un regalo velocemente',
                      type: AppButtonType.secondary,
                      onPressed: () {
                        // TODO: Navigare alla pagina di generazione rapida
                      },
                    ),
                    const SizedBox(height: AppTheme.spaceXL),
                    
                    // Link per registrazione
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Non hai un account?',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        AppButton(
                          text: 'Registrati',
                          type: AppButtonType.text,
                          onPressed: () {
                            Navigator.of(context).pushNamed(RegisterPage.routeName);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}