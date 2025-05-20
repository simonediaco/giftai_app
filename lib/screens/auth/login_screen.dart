import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:giftai/blocs/auth/auth_bloc.dart';
import 'package:giftai/blocs/auth/auth_event.dart';
import 'package:giftai/blocs/auth/auth_state.dart';
import 'package:giftai/screens/auth/register_screen.dart';
import 'package:giftai/screens/home/home_screen.dart';
import 'package:giftai/screens/wizard/wizard_screen.dart';
import 'package:giftai/services/firebase_service.dart';
import 'package:giftai/utils/validation_utils.dart';
import 'package:giftai/widgets/common/primary_button.dart';
import 'package:giftai/screens/auth/register_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // FirebaseService.setCurrentScreen('login_screen');
  }

  void _onLoginPressed() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final formData = _formKey.currentState!.value;
      context.read<AuthBloc>().add(
        AuthLoginRequested(
          username: formData['username'],
          password: formData['password'],
        ),
      );
      
      // Log evento
      // FirebaseService.logEvent(
      //   name: 'login_attempt',
      //   parameters: {'method': 'email_password'},
      // );
    }
  }

  void _onContinueAsGuestPressed() {
    // FirebaseService.logEvent(
    //   name: 'continue_as_guest',
    // );
    
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const WizardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            setState(() {
              _isLoading = true;
            });
          } else {
            setState(() {
              _isLoading = false;
            });
            
            if (state is AuthAuthenticated) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                
                // Logo
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 120,
                    height: 120,
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Titolo
                const Text(
                  'Bentornato!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 8),
                
                const Text(
                  'Accedi per gestire i tuoi destinatari e regali',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 40),
                
                // Form di login
                FormBuilder(
                  key: _formKey,
                  child: Column(
                    children: [
                      FormBuilderTextField(
                        name: 'username',
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: ValidationUtils.required('Username'),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      FormBuilderTextField(
                        name: 'password',
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                        ),
                        obscureText: true,
                        validator: ValidationUtils.validatePassword,
                      ),
                      
                      const SizedBox(height: 8),
                      
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // TODO: implementare recupero password
                          },
                          child: const Text('Password dimenticata?'),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      PrimaryButton(
                        text: 'Accedi',
                        isLoading: _isLoading,
                        onPressed: _onLoginPressed,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Non hai un account?'),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                ),
                              );
                            },
                            child: const Text('Registrati'),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Divider
                      const Row(
                        children: [
                          Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text('oppure'),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Continua come ospite
                      OutlinedButton(
                        onPressed: _onContinueAsGuestPressed,
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: const Text('Continua senza accesso'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}