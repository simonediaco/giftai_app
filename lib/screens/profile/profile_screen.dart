import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:giftai/blocs/auth/auth_bloc.dart';
import 'package:giftai/blocs/auth/auth_event.dart';
import 'package:giftai/blocs/auth/auth_state.dart';
import 'package:giftai/screens/auth/login_screen.dart';
import 'package:giftai/services/firebase_service.dart';
import 'package:giftai/widgets/common/primary_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isLoading = false;
  bool _isEditing = false;
  
  @override
  void initState() {
    super.initState();
    // FirebaseService.setCurrentScreen('profile_screen');
  }
  
  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Sei sicuro di voler effettuare il logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annulla'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogoutRequested());
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
  
  void _saveProfile() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final formData = _formKey.currentState!.value;
      
      setState(() {
        _isLoading = true;
      });
      
      context.read<AuthBloc>().add(
        AuthProfileUpdateRequested(
          firstName: formData['first_name'],
          lastName: formData['last_name'],
          bio: formData['bio'],
          phoneNumber: formData['phone_number'],
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Il mio profilo'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.close : Icons.edit),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },
          ),
        ],
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthProfileUpdateSuccess) {
            setState(() {
              _isLoading = false;
              _isEditing = false;
            });
            
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profilo aggiornato con successo')),
            );
          } else if (state is AuthProfileUpdateFailure) {
            setState(() {
              _isLoading = false;
            });
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Errore: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthAuthenticated && state.user != null) {
            final user = state.user!;
            
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: FormBuilder(
                key: _formKey,
                enabled: _isEditing,
                initialValue: {
                  'username': user.username,
                  'email': user.email,
                  'first_name': user.firstName,
                  'last_name': user.lastName,
                  'bio': user.profile?.bio ?? '',
                  'phone_number': user.profile?.phoneNumber ?? '',
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: user.profile?.avatar != null
                          ? NetworkImage(user.profile!.avatar!)
                          : null,
                      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      child: user.profile?.avatar == null
                          ? Text(
                              user.firstName.isNotEmpty
                                  ? user.firstName[0].toUpperCase()
                                  : user.username[0].toUpperCase(),
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )
                          : null,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Nome completo
                    Text(
                      '${user.firstName} ${user.lastName}'.trim(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Username e email
                    Text(
                      '@${user.username}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      user.email,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Campi form
                    const Text(
                      'Informazioni personali',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Nome
                    FormBuilderTextField(
                      name: 'first_name',
                      decoration: const InputDecoration(
                        labelText: 'Nome',
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                      enabled: _isEditing,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Cognome
                    FormBuilderTextField(
                      name: 'last_name',
                      decoration: const InputDecoration(
                        labelText: 'Cognome',
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                      enabled: _isEditing,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Bio
                    FormBuilderTextField(
                      name: 'bio',
                      decoration: const InputDecoration(
                        labelText: 'Bio',
                        prefixIcon: Icon(Icons.info),
                        hintText: 'Scrivi qualcosa su di te',
                      ),
                      maxLines: 3,
                      enabled: _isEditing,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Telefono
                    FormBuilderTextField(
                      name: 'phone_number',
                      decoration: const InputDecoration(
                        labelText: 'Numero di telefono',
                        prefixIcon: Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.phone,
                      enabled: _isEditing,
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Pulsante salva
                    if (_isEditing)
                      PrimaryButton(
                        text: 'Salva modifiche',
                        isLoading: _isLoading,
                        onPressed: _saveProfile,
                      ),
                    
                    const SizedBox(height: 32),
                    
                    // Sezione Info Account
                    const Text(
                      'Account',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Info account
                    ListTile(
                      leading: const Icon(Icons.email),
                      title: const Text('Email'),
                      subtitle: Text(user.email),
                      tileColor: Colors.grey[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('Username'),
                      subtitle: Text(user.username),
                      tileColor: Colors.grey[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Pulsante logout
                    OutlinedButton.icon(
                      onPressed: _logout,
                      icon: const Icon(Icons.logout, color: Colors.red),
                      label: const Text(
                        'Logout',
                        style: TextStyle(color: Colors.red),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        minimumSize: const Size.fromHeight(50),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}