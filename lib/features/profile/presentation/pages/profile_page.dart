// lib/features/profile/presentation/pages/profile_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_event.dart';
import '../../../../features/auth/presentation/bloc/auth_state.dart';
import '../../../../shared/widgets/app_button.dart';

class ProfilePage extends StatelessWidget {
  static const routeName = '/profile';
  
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Il mio profilo'),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spaceL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Avatar e nome
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text(
                        state.user.name?.substring(0, 1).toUpperCase() ?? 'U',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppTheme.spaceL),
                    Text(
                      state.user.name ?? 'Utente',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      state.user.email,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppTheme.spaceL),
                    
                    // Separatore
                    const Divider(),
                    const SizedBox(height: AppTheme.spaceL),
                    
                    // Sezione impostazioni
                    _buildSettingItem(
                      context,
                      icon: Icons.person_outline,
                      title: 'Dettagli profilo',
                      subtitle: 'Modifica i tuoi dati personali',
                      onTap: () {
                        // TODO: Implementare modifica profilo
                      },
                    ),
                    _buildSettingItem(
                      context,
                      icon: Icons.notifications_outlined,
                      title: 'Notifiche',
                      subtitle: 'Gestisci le preferenze di notifica',
                      onTap: () {
                        // TODO: Implementare notifiche
                      },
                    ),
                    _buildSettingItem(
                      context,
                      icon: Icons.dark_mode_outlined,
                      title: 'Tema',
                      subtitle: 'Cambia tema chiaro/scuro',
                      onTap: () {
                        // TODO: Implementare cambio tema
                      },
                    ),
                    _buildSettingItem(
                      context,
                      icon: Icons.language_outlined,
                      title: 'Lingua',
                      subtitle: 'Cambia lingua dell\'app',
                      onTap: () {
                        // TODO: Implementare cambio lingua
                      },
                    ),
                    _buildSettingItem(
                      context,
                      icon: Icons.help_outline,
                      title: 'Aiuto',
                      subtitle: 'Domande frequenti e supporto',
                      onTap: () {
                        // TODO: Implementare aiuto
                      },
                    ),
                    _buildSettingItem(
                      context,
                      icon: Icons.info_outline,
                      title: 'Informazioni',
                      subtitle: 'Informazioni sull\'app e versione',
                      onTap: () {
                        // TODO: Implementare info
                      },
                    ),
                    const SizedBox(height: AppTheme.spaceXL),
                    
                    // Pulsante logout
                    AppButton(
                      text: 'Esci',
                      type: AppButtonType.secondary,
                      icon: const Icon(Icons.logout),
                      onPressed: () {
                        context.read<AuthBloc>().add(LogoutRequested());
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surface,
      margin: const EdgeInsets.only(bottom: AppTheme.spaceM),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spaceM),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppTheme.spaceM),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: AppTheme.spaceM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}