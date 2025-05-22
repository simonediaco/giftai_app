// lib/features/profile/presentation/pages/profile_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/golden_accents.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_event.dart';
import '../../../../features/auth/presentation/bloc/auth_state.dart';
import '../../../../features/auth/presentation/pages/login_page.dart';
import '../../../../shared/widgets/app_button.dart';

class ProfilePage extends StatelessWidget {
  static const routeName = '/profile';
  
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // ✅ Naviga al login quando logout completato
        if (state is Unauthenticated) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            LoginPage.routeName,
            (route) => false,
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
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
                      // Avatar e nome con tocco oro
                      Stack(
                        children: [
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
                          // ✅ Badge oro per utente premium
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                gradient: GoldenAccents.goldGradient,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.verified,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
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
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Modifica profilo - Coming soon!')),
                          );
                        },
                      ),
                      _buildSettingItem(
                        context,
                        icon: Icons.notifications_outlined,
                        title: 'Notifiche',
                        subtitle: 'Gestisci le preferenze di notifica',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Notifiche - Coming soon!')),
                          );
                        },
                      ),
                      _buildSettingItem(
                        context,
                        icon: Icons.dark_mode_outlined,
                        title: 'Tema',
                        subtitle: 'Cambia tema chiaro/scuro',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Cambio tema - Coming soon!')),
                          );
                        },
                      ),
                      _buildSettingItem(
                        context,
                        icon: Icons.language_outlined,
                        title: 'Lingua',
                        subtitle: 'Cambia lingua dell\'app',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Cambio lingua - Coming soon!')),
                          );
                        },
                      ),
                      _buildSettingItem(
                        context,
                        icon: Icons.help_outline,
                        title: 'Aiuto',
                        subtitle: 'Domande frequenti e supporto',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Aiuto - Coming soon!')),
                          );
                        },
                      ),
                      _buildSettingItem(
                        context,
                        icon: Icons.info_outline,
                        title: 'Informazioni',
                        subtitle: 'Informazioni sull\'app e versione',
                        onTap: () {
                          _showAppInfo(context);
                        },
                      ),
                      const SizedBox(height: AppTheme.spaceXL),
                      
                      // ✅ Pulsante logout funzionante
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, authState) {
                          return AppButton(
                            text: 'Esci',
                            type: AppButtonType.secondary,
                            icon: const Icon(Icons.logout),
                            isLoading: authState is AuthLoading,
                            onPressed: () => _showLogoutDialog(context),
                          );
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
      ),
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
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
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
  
  // ✅ Dialog di conferma logout
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(width: AppTheme.spaceS),
            const Text('Conferma Logout'),
          ],
        ),
        content: const Text(
          'Sei sicuro di voler uscire dall\'app?\n\nDovrai effettuare nuovamente il login per accedere.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Annulla'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () {
              Navigator.of(ctx).pop(); // Chiudi dialog
              context.read<AuthBloc>().add(LogoutRequested()); // ✅ Esegui logout
            },
            child: const Text(
              'Esci',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
  
  // ✅ Dialog info app
  void _showAppInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            GoldenAccents.goldenIcon(Icons.info),
            const SizedBox(width: AppTheme.spaceS),
            const Text('Donatello'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('🎨 Donatello - Gift AI'),
            SizedBox(height: AppTheme.spaceS),
            Text('Versione: 1.0.0'),
            SizedBox(height: AppTheme.spaceS),
            Text('Un\'app per generare idee regalo personalizzate con l\'intelligenza artificiale.'),
            SizedBox(height: AppTheme.spaceM),
            Text(
              'Ispirata al maestro Donatello e alla sua arte rinascimentale.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Chiudi'),
          ),
        ],
      ),
    );
  }
}