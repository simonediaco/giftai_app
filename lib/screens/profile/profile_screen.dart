import 'package:flutter/material.dart';
import '../../widgets/empty_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Per ora utilizziamo una schermata di profilo statica
    // In una versione reale, questo verrebbe caricato da un repository
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sezione profilo
          Center(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blue,
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Mario Rossi',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'mario.rossi@example.com',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
          
          // Statistiche
          _buildStatisticsCard(context),
          
          const SizedBox(height: 24),
          
          // Menu impostazioni
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  _buildSettingsItem(
                    context: context,
                    icon: Icons.person_outline,
                    title: 'Modifica profilo',
                    subtitle: 'Cambia nome, email e password',
                    onTap: () {
                      _showFeatureInDevelopment(context);
                    },
                  ),
                  const Divider(),
                  _buildSettingsItem(
                    context: context,
                    icon: Icons.notifications_outlined,
                    title: 'Notifiche',
                    subtitle: 'Gestisci preferenze notifiche',
                    onTap: () {
                      _showFeatureInDevelopment(context);
                    },
                  ),
                  const Divider(),
                  _buildSettingsItem(
                    context: context,
                    icon: Icons.color_lens_outlined,
                    title: 'Tema',
                    subtitle: 'Cambia tema dell\'app',
                    onTap: () {
                      _showFeatureInDevelopment(context);
                    },
                  ),
                  const Divider(),
                  _buildSettingsItem(
                    context: context,
                    icon: Icons.language_outlined,
                    title: 'Lingua',
                    subtitle: 'Italiano',
                    onTap: () {
                      _showFeatureInDevelopment(context);
                    },
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Menu supporto
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  _buildSettingsItem(
                    context: context,
                    icon: Icons.help_outline,
                    title: 'Aiuto',
                    subtitle: 'FAQ e supporto',
                    onTap: () {
                      _showFeatureInDevelopment(context);
                    },
                  ),
                  const Divider(),
                  _buildSettingsItem(
                    context: context,
                    icon: Icons.policy_outlined,
                    title: 'Privacy',
                    subtitle: 'Informativa sulla privacy',
                    onTap: () {
                      _showFeatureInDevelopment(context);
                    },
                  ),
                  const Divider(),
                  _buildSettingsItem(
                    context: context,
                    icon: Icons.info_outline,
                    title: 'Informazioni',
                    subtitle: 'Versione 1.0.0',
                    onTap: () {
                      _showFeatureInDevelopment(context);
                    },
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Pulsante logout
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                _showLogoutConfirmation(context);
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
              ),
            ),
          ),
          
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildStatisticsCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Statistiche',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  context: context,
                  icon: Icons.card_giftcard,
                  value: '24',
                  label: 'Regali generati',
                ),
                _buildStatItem(
                  context: context,
                  icon: Icons.people,
                  value: '8',
                  label: 'Destinatari',
                ),
                _buildStatItem(
                  context: context,
                  icon: Icons.bookmark,
                  value: '12',
                  label: 'Regali salvati',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required BuildContext context,
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 28,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildSettingsItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _showFeatureInDevelopment(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Funzionalità in sviluppo'),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Sei sicuro di voler effettuare il logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annulla'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showFeatureInDevelopment(context);
            },
            child: const Text('Logout'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}