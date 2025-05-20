// File: lib/screens/auth/register_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:giftai/blocs/auth/auth_bloc.dart';
import 'package:giftai/blocs/auth/auth_event.dart';
import 'package:giftai/blocs/auth/auth_state.dart';
import 'package:giftai/screens/auth/login_screen.dart';
import 'package:giftai/services/firebase_service.dart';
import 'package:giftai/utils/validation_utils.dart';
import 'package:giftai/widgets/common/primary_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // FirebaseService.setCurrentScreen('register_screen');
  }

  void _onRegisterPressed() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final formData = _formKey.currentState!.value;
      
      if (formData['password'] != formData['password_confirm']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Le password non corrispondono')),
        );
        return;
      }
      
      context.read<AuthBloc>().add(
        AuthRegisterRequested(
          username: formData['username'],
          email: formData['email'],
          password: formData['password'],
          passwordConfirm: formData['password_confirm'],
          firstName: formData['first_name'],
          lastName: formData['last_name'],
        ),
      );
      
      // Log evento
      // FirebaseService.logEvent(
        // name: 'register_attempt',
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrazione'),
      ),
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
            
            if (state is AuthRegistrationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Registrazione completata. Ora puoi accedere.')),
              );
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            } else if (state is AuthRegistrationFailure) {
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
                const SizedBox(height: 20),
                
                // Logo
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 100,
                    height: 100,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Titolo
                const Text(
                  'Crea il tuo account',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 8),
                
                const Text(
                  'Registrati per salvare i tuoi destinatari e idee regalo',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 32),
                
                // Form di registrazione
                FormBuilder(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Nome
                      FormBuilderTextField(
                        name: 'first_name',
                        decoration: const InputDecoration(
                          labelText: 'Nome',
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: ValidationUtils.required('Nome'),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Cognome
                      FormBuilderTextField(
                        name: 'last_name',
                        decoration: const InputDecoration(
                          labelText: 'Cognome',
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: ValidationUtils.required('Cognome'),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Username
                      FormBuilderTextField(
                        name: 'username',
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          prefixIcon: Icon(Icons.account_circle),
                        ),
                        validator: ValidationUtils.required('Username'),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Email
                      FormBuilderTextField(
                        name: 'email',
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.email(),
                        ]),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Password
                      FormBuilderTextField(
                        name: 'password',
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                        ),
                        obscureText: true,
                        validator: ValidationUtils.validatePassword,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Conferma password
                      FormBuilderTextField(
                        name: 'password_confirm',
                        decoration: const InputDecoration(
                          labelText: 'Conferma Password',
                          prefixIcon: Icon(Icons.lock),
                        ),
                        obscureText: true,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          (value) {
                            if (value != _formKey.currentState?.fields['password']?.value) {
                              return 'Le password non corrispondono';
                            }
                            return null;
                          },
                        ]),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      PrimaryButton(
                        text: 'Registrati',
                        isLoading: _isLoading,
                        onPressed: _onRegisterPressed,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Hai già un account?'),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Accedi'),
                          ),
                        ],
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